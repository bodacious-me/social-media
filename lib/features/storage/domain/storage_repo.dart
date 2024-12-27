import 'dart:typed_data';

abstract class StorageRepo {

  Future<String?> uploadProfileImageMobile(String path, String filename);

  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String filename); 
}