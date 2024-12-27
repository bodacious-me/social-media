import 'package:social_media_app/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<void> deletePost();
  Future<List<Post>> fetchPostByUserId();
}