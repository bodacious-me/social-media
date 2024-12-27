import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileimageurl;

  ProfileUser(
      {required super.id,
      required super.email,
      required super.name,
      required this.profileimageurl,
      required this.bio
      });

  // method to update profile
  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
        id: id,
        email: email,
        name: name,
        profileimageurl: newProfileImageUrl ?? profileimageurl,
        bio: newBio ?? bio);
  }

  // profile user -> json
@override
  Map<String, dynamic> toJson() {
    return ({
      'id': id,
      'email': email,
      'profileimageurl': profileimageurl,
      'name': name,
      'bio': bio
    });
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        profileimageurl: json['profileimageurl'] ?? '',
        bio: json['bio'] ?? '');
  }
}
