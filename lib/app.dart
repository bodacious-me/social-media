import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/data/supabase_auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_app/features/home/presentation/home_page.dart';
import 'package:social_media_app/features/profile/data/supabase_profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/storage/data/supabase_storage_repo.dart';
import 'package:social_media_app/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  final authRepo = SupabaseAuthRepo();
  final profileRepo = SupabaseProfileRepo();
  final storageRepo = SupabaseStorageRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provide cubit to app
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepo: authRepo)..checkAuth()),
        BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
                profileRepo: profileRepo, storageRepo: storageRepo))
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightmode,
          home: BlocConsumer<AuthCubit, AuthStates>(
              builder: (context, authState) {
            print(authState);
            if (authState is UnAuthentiacted) {
              return const AuthPage();
            }
            if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            // listen for errors
          }, listener: (context, state) {
            if (state is AuthErrors) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          })),
    );
  }
}
