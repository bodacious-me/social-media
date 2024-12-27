import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/componenets/auth_textFiled.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // mobile image pick
  PlatformFile? imagePickedFile;
  // web image pick
  Uint8List? webImage;

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  final bioTextController = TextEditingController();

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;

    if (imagePickedFile != null || newBio != null) {
      await profileCubit.updatedProfile(
        email: widget.user.email,
        newBio: bioTextController.text,
        Unit8BytesWeb: imageWebBytes,
        filePathWeb: imageMobilePath,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(builder: (context, state) {
      // edit profile loading
      if (state is ProfileLoading) {
        return const Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              const SizedBox(
                height: 25,
              ),
              Text('Profile Loading')
            ],
          ),
        ));
      } else {
        return buildEditPage();
      }
    }, listener: (context, state) {
      if (state is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildEditPage() {
    String imageUrl = widget.user.profileimageurl; // Original URL
    String uniqueUrl =
        '$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}';

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: updateProfile,
                icon: Icon(
                  Icons.upload,
                  color: Theme.of(context).colorScheme.primary,
                )),
          )
        ],
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 125.0),
          child: Text('Edit Profile'),
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // profile pic
          Center(
            child: Container(
                height: 200,
                width: 200,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: (!kIsWeb && imagePickedFile != null)
                    ? Image.file(
                        File(imagePickedFile!.path!),
                        fit: BoxFit.cover,
                      )
                    : (kIsWeb && webImage != null)
                        ? Image.memory(
                            webImage!,
                            fit: BoxFit.cover,
                          )

                        ///
                        : CachedNetworkImage(
                            imageUrl: uniqueUrl,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 72,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            imageBuilder: (context, ImageProvider) => Image(
                              image: ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          )
                /////
                ),
          ),

          const SizedBox(
            height: 12,
          ),

          const SizedBox(
            height: 12,
          ),
          Center(
            child: MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text('Pick Image'),
            ),
          ),

          const SizedBox(
            height: 12,
          ),
          const Text('Bio'),

          const SizedBox(
            height: 25,
          ),
          // bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: AuthTextfiled(
                controller: bioTextController,
                hintText: widget.user.bio,
                obsecureText: false),
          ),
        ],
      ),
    );
  }
}
