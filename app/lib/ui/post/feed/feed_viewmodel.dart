import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../domain/entities/post_entity.dart';

class FeedViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final PostRepository _postRepository;

  List<Post> _posts = [];

  List<Post> get posts => UnmodifiableListView(_posts);

  late final StreamSubscription<List<Post>> subscription;

  late final logoutCommand = Command0(_authRepository.logout);

  late final getPostsCommand = Command0(_getPosts);

  FeedViewmodel(this._authRepository, this._postRepository) {
    subscription = _postRepository //
        .observerListPost
        .listen(_updateScreen);
  }

  AsyncResult<List<Post>> _getPosts() => //
      _postRepository.getPosts().onSuccess(_updateScreen);

  void _updateScreen(List<Post> value) {
    _posts = value;
    notifyListeners();
  }

  Future<void> onShared(Post post) async {
    final text = '''
      ${post.author.firstName} ${post.author.lastName} compartilhou um post:
        
      ${post.description}
      
      Baíxe o app da Fluterrando e saíba mais!
      https://github.com/Flutterando/flutterando_app/releases
      ''';
    Share.share(text.trim());
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
