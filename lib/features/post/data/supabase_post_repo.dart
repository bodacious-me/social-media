import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repos/post_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePostRepo implements PostRepo {
  final _supabasePost = Supabase.instance.client.storage.from('images');

  @override
  Future<void> createPost(Post post) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchAllPosts() {
    // TODO: implement fetchAllPosts
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchPostByUserId() {
    // TODO: implement fetchPostByUserId
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost() {
    // TODO: implement deletePost
    throw UnimplementedError();
  }
}
