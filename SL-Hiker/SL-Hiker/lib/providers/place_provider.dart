
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class PlaceProvider with ChangeNotifier{

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<bool> setPlace(String name,String info, File? image) async{

    try{
      _isLoading = true;
      notifyListeners();

     String? pathUrl =  await _uploadImage(image);

     if(pathUrl == null){
       _isLoading = false;
       notifyListeners();
       return false;
     }

     print(pathUrl);
     DocumentReference docRef = await FirebaseFirestore.instance.collection("places").doc();

     Map<String,dynamic>? data = {
        "placeId":docRef.id,
        "info": info,
        "name" : name,
        "location" : "Sri Lanka",
        "lat":"7.0733245",
        "long":"80.503499",
        "image":"$pathUrl",
        "maplink":"https://www.google.com/maps/place/Kabaragala+Peak/@7.0733245,80.503499,17z/data=!3m1!4b1!4m6!3m5!1s0x3ae37584bcc3576f:0x2a7a7e46ea27d578!8m2!3d7.0733245!4d80.503499!16s%2Fg%2F11h7d0v4yh?entry=ttu",
      };

      docRef.set(data);

      _isLoading = false;
      notifyListeners();
      return true;
    }catch(firebaseException){
      print("Data Save Error: $firebaseException");
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<String?> _uploadImage(File? _image) async {
    if (_image == null) return null;

    final fileName = _image.path.split('/').last;
    final ref = FirebaseStorage.instance.ref().child("$fileName");

    try {
      await ref.putFile(_image!);
      final url = await ref.getDownloadURL();
      print("✅ Image uploaded: $url");
      return url;

    } catch (e) {
      print("❌ Upload error: $e");
      return null;

    }

  }

}