import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../../board/models/models.dart';
import '../../post/models/models.dart';

import '../exceptions/exceptions.dart';
import '../../../core/exceptions/exceptions.dart';

abstract class CaptchaRemoteDatasource {
  Future<CaptchaChallengeModel> getCaptchaChallenge(
      BoardModel board, PostModel? thread);
}

class CaptchaRemoteDatasourceImpl implements CaptchaRemoteDatasource {
  final String apiUrl = 'https://sys.4channel.org/captcha';
  final String errorKey = 'error';

  @override
  Future<CaptchaChallengeModel> getCaptchaChallenge(
    BoardModel board,
    PostModel? thread,
  ) async {
    String url = '$apiUrl?board=$board';
    if (thread != null) {
      url += '&thread_id=$thread';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        if (responseJson.containsKey(errorKey)) {
          throw CaptchaChallengeException.fromJson(responseJson);
        } else {
          CaptchaChallengeModel captchaChallenge =
              CaptchaChallengeModel.fromJson(responseJson);
          return captchaChallenge;
        }
      } on Exception {
        throw JsonDecodeException();
      }
    } else {
      throw NetworkException();
    }
  }
}
