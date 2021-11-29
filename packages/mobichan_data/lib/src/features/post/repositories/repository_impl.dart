import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:mobichan_data/mobichan_data.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDatasource localDatasource;
  final PostRemoteDatasource remoteDatasource;

  PostRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<List<Post>> addThreadToHistory(Post thread, Board board) async {
    return localDatasource.addThreadToHistory(
      PostModel.fromEntity(thread),
      BoardModel.fromEntity(board),
    );
  }

  @override
  Future<List<Post>> getPosts(
      {required Board board, required Post thread}) async {
    return remoteDatasource.getPosts(
      board: BoardModel.fromEntity(board),
      thread: PostModel.fromEntity(thread),
    );
  }

  @override
  Future<List<Post>> getThreads({required Board board, required Sort sort}) {
    return remoteDatasource.getThreads(
      board: BoardModel.fromEntity(board),
      sort: sort,
    );
  }

  @override
  Future<void> postReply({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post resto,
    required Post post,
    String? filePath,
  }) {
    return remoteDatasource.postReply(
      board: BoardModel.fromEntity(board),
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      resto: PostModel.fromEntity(resto),
      post: PostModel.fromEntity(post),
      filePath: filePath,
    );
  }

  @override
  Future<void> postThread({
    required Board board,
    required String captchaChallenge,
    required String captchaResponse,
    required Post post,
    String? filePath,
  }) {
    return remoteDatasource.postThread(
      board: BoardModel.fromEntity(board),
      captchaChallenge: captchaChallenge,
      captchaResponse: captchaResponse,
      post: PostModel.fromEntity(post),
      filePath: filePath,
    );
  }

  @override
  Future<List<Post>> getHistory() async {
    return localDatasource.getHistory();
  }
}
