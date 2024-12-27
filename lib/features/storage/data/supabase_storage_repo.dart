import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageRepo implements StorageRepo {
  @override
  Future<String?> uploadProfileImageMobile(String path, String filename) async {
    try {
      final file = File(path);
      await Supabase.instance.client.storage
          .from('images')
          .update(path, file)
          .then((value) => const ScaffoldMessenger(
              child: SnackBar(content: Text('upload Successfull'))));

      final String url =
          Supabase.instance.client.storage.from('images').getPublicUrl(path);
      return url;
    } catch (e) {
      print('tr heeeew ${e}');
    }
    return null;
  }

  @override
  Future<String?> uploadProfileImageWeb(
      Uint8List fileBytes, String filename) async {
    try {
      final storagePath = 'profiles/${filename}';

      final supabase = Supabase.instance.client;

      // Check if the file already exists
      final List<FileObject> files =
          await supabase.storage.from('images').list(path: 'profiles');

      bool fileExists = files.any((file) => file.name == filename);

      if (fileExists) {
        // File exists, update it
        await supabase.storage
            .from('images')
            .updateBinary(storagePath, fileBytes);
        print('File updated successfully: $storagePath');
      } else {
        // File does not exist, upload it
        await supabase.storage
            .from('images')
            .uploadBinary(storagePath, fileBytes);
        print('File uploaded successfully: $storagePath');
      }

      final String url = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl('profiles/${filename}');
      print(url);
      return url;
    } catch (e) {
      print('tr heeeew?? the url: ${e}');
    }
    return null;
  }

  // https://fwidydevzbbjxemvitol.supabase.co/storage/v1/object/public/images/nameworkingone@gmail.com
  // https://fwidydevzbbjxemvitol.supabase.co/storage/v1/object/public/images/image.jpg

  // Future<void> _uploadFileMobile(String path, String filename) async {
  //   try {
  //     final file = File(path);
  //     await Supabase.instance.client.storage
  //         .from('images')
  //         .upload(path, file)
  //         .then((value) => const ScaffoldMessenger(
  //             child: SnackBar(content: Text('upload Successfull'))));
  //   } catch (e) {
  //     print('tr heeeew ${e}');
  //   }
  // }

  // Future<void> _uploadFileWeb(Uint8List fileBytes, String filename) async {
  //   try {
  //     await Supabase.instance.client.storage
  //         .from('images')
  //         .uploadBinary(filename, fileBytes)
  //         .then((value) => const ScaffoldMessenger(
  //             child: SnackBar(content: Text('upload Successfull'))));
  //   } catch (e) {
  //     print('tr heeeew ${e}');
  //   }
  // }
}
