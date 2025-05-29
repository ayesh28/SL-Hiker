import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class UserAuthProvider with ChangeNotifier{
  UserModel? _userModel;
  bool _isLoading = false;
  // types.Room? _room;

  UserModel? get  userModel => _userModel;
  bool get isLoading => _isLoading;
  // types.Room? get room => _room;



  Future<void> getUserDetails() async{
    final doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid??"").get();
    if(doc != null){
      _userModel = UserModel.fromJson(doc.data()!);
      notifyListeners();
    }
  }

  Future<bool> signup(String email,String password,String name) async{
    try{
      _isLoading = true;
      notifyListeners();

      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email??"", password: password??"");
      User? user = result.user;

      if (user == null) throw Exception("User is null");

        Map<String,dynamic>? data = {
          "user_id": user?.uid,
          "name" : name,
        };
     
        await FirebaseFirestore.instance.collection("users").doc(user?.uid).set(data);

        _userModel = UserModel.fromJson(data);
        _isLoading = false;

        notifyListeners();
        return true;

    }catch(firebaseException){
      print("Authentication Error: $firebaseException");
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> signin(String email,String password) async{
    try{
      _isLoading = true;
      notifyListeners();

      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email??"", password: password??"");
      User? user = result.user;

      if (user == null) throw Exception("User is null");

      await getUserDetails();

      _isLoading = false;
      notifyListeners();
      return true;

    }catch(firebaseException){
      print("SignIn Error: $firebaseException");
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // Future<void> createAchatUser() async{
  //   User? chatUser = FirebaseChatCore.instance.firebaseUser;
  //
  //     await FirebaseChatCore.instance.createUserInFirestore(
  //         types.User(
  //           id: _userModel?.id??"",
  //           firstName: _userModel?.name,
  //         )
  //     ).then((onValue) async {
  //       await joinGlobalChat("9SJvewH8xF8GpRyX7NrH");
  //     });
  //
  // }

  // Future<void> joinGlobalChat(String globalRoomId) async {
  //
  //   final myId   = _userModel?.id;
  //
  //   final room = await FirebaseChatCore.instance.room(globalRoomId).first;
  //
  //   _room = room;
  //   notifyListeners();
  //
  //   if (!room!.users.any((u) => u.id == myId)) {
  //     final me = types.User(id: myId??"");
  //     final updatedRoom = room.copyWith(
  //       users: [...room.users,me],
  //     );
  //
  //     FirebaseChatCore.instance.updateRoom(updatedRoom);
  //   }
  // }

  Future<bool> isLogedIn()async{
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser !=null){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> signOut()async{
    try{
      await FirebaseAuth.instance.signOut();
    }catch(e){
      print(e);
    }
  }

}