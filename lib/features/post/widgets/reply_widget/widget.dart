import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:screenshot/screenshot.dart';

class ReplyWidget extends StatelessWidget {
  final Board board;
  final Post post;
  final List<Post> threadReplies;
  final int recursion;
  final bool inDialog;
  final bool showReplies;

  ReplyWidget({
    required this.board,
    required this.post,
    required this.threadReplies,
    this.recursion = 0,
    this.inDialog = false,
    this.showReplies = false,
    Key? key,
  }) : super(key: key);

  final screenshotController = ScreenshotController();

  double computePadding(int recursion) {
    if (recursion == 0 || recursion == 1) {
      return 0;
    } else {
      return 15.0 * (recursion - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: computePadding(recursion)),
                child: Stack(
                  children: [
                    buildIndentBar(),
                    Padding(
                      padding: EdgeInsets.only(left: recursion > 0 ? 14 : 0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    buildFlag(),
                                    buildName(),
                                    const SizedBox(width: 5),
                                    buildNumber(context),
                                  ],
                                ),
                              ),
                              buildPopupMenuButton(),
                            ],
                          ),
                          if (post.filename != null) buildImage(),
                          const SizedBox(height: 5),
                          ContentWidget(
                            board: board,
                            reply: post,
                            inDialog: inDialog,
                            threadReplies: threadReplies,
                          ),
                          if (showReplies) buildFooter(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String insertATags(String? str) {
    if (str == null) {
      return '';
    }
    final regExp = RegExp(
      r'(?<!(href="))http[s?]:\/\/[^\s<]+(?!<\/a>)',
    );
    return str.removeWbr.replaceAllMapped(regExp, (match) {
      return '<a href="${match.group(0)}">${match.group(0)}</a>';
    });
  }
}