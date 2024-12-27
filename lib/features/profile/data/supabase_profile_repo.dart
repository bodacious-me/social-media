import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileRepo implements ProfileRepo {
  final _database = Supabase.instance.client;
  // gets the user document from database

  @override
  Future<ProfileUser?> fetchUserProfile(String email) async {
    try {
      final userDoc =
          await _database.from('users').select().eq('email', email).single();

      if (userDoc.isNotEmpty) {
        return ProfileUser(
            id: userDoc['id'],
            email: userDoc['email'],
            name: userDoc['name'],
            profileimageurl: userDoc['profileimageurl'] ?? '',
            bio: userDoc['bio'] ?? '');
      } 
      else{
        return null;
      }
    } catch (e) {
      print('Error ${email} user profile: $e');
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile, String email) async {
    try {
      await _database.from('users').update({
        'name': updatedProfile.name,
        'email': updatedProfile.email,
        'bio': updatedProfile.bio,
        'id': updatedProfile.id,
        'profileimageurl': updatedProfile.profileimageurl
      }).eq('email', email);
    } catch (e) {
      print('tr heeew:   ${e}');
      throw Exception(e);
    }
  }
}
