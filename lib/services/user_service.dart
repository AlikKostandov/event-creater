import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../entity/simple_user.dart';

class UserService {
  // Get SimpleUser by email of auth User
  static Future<SimpleUser?> getUser(String? email) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.120:9000/event-creator/users?email=${email!}'));
    if (response.statusCode == 200) {
      String jsonBody = response.body;
      dynamic data = jsonDecode(jsonBody);
      return SimpleUser.fromJson(data);
    } else {
      throw const HttpException('Failed to get user by email');
    }
  }

  // Get user avatar by SimpleUser id
  static Future<Uint8List?> getUserAvatar(int? id) async {
    final response = await http.get(
        Uri.parse('http://192.168.1.120:9000/event-creator/users/$id/avatar'));
    if (response.statusCode == 200) {
      String avatar = response.body;
      return avatar.isNotEmpty ? base64Decode(avatar) : null;
    } else {
      throw const HttpException('Failed to get user\'s avatar');
    }
  }

  // Upload avatar for user
  static Future<void> uploadAvatar(int? id) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      final compressedImage = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        quality: 50,
      );

      if (id != null && compressedImage != null) {
        String image = base64Encode(compressedImage);

        final response = await http.put(
            Uri.parse(
                'http://192.168.1.120:9000/event-creator/users/$id/avatar-upload'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: image);

        if (response.statusCode != 200) {
          throw const HttpException('Failed to upload user\'s avatar');
        }
      }
    }
  }

  // The function of user registration in the database
  static Future<void> registerUser(SimpleUser user) async {
    var jsonBody = jsonEncode(user.toJson());
    final response = await http.post(
        Uri.parse('http://192.168.1.120:9000/event-creator/users/registry'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonBody);
    if (response.statusCode != 200) {
      throw const HttpException('Failed to register user');
    }
  }
}
