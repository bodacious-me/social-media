import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repository/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepo implements AuthRepo {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _databse = Supabase.instance.client.from('users');
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(password: password, email: email);
      final supaUser = _supabase.auth.currentUser;
      AppUser user = AppUser(email: email, name: '', id: supaUser!.id);
      return user;
    } catch (e) {
      throw Exception('Login Failed! ${e}');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPasswordName(
      String email, String password,String name) async {
    try {
      await _supabase.auth.signUp(password: password, email: email);
      final supaUser = _supabase.auth.currentUser;
      AppUser user = AppUser(email: email, name: name, id: supaUser!.id);
      await _databse.insert({'name':user.name,'email':user.email});

      return user;
    } catch (e) {
      throw Exception('SignUp Failed! ${e}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('LogOut Failed! ${e}');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final supaUser = _supabase.auth.currentUser;
      if (supaUser != null) {
        AppUser user = AppUser(
            email: supaUser.email.toString(),
            name: '',
            id: supaUser.id.toString());
        return user;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Cannot Get Current User! ${e}');
    }
  }
}
