import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutterappaes/Model/Token.dart';
import 'package:flutterappaes/Model/Users.dart';
class Firestore{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messageReferance =FirebaseFirestore.instance.collection('message');
  addUsers(UserModel user)  {
    var users = FirebaseFirestore.instance.collection('users').doc(
      user.id
    ).set(user.tojson());
  }
  FirebaseMessaging _fcm=FirebaseMessaging.instance;

  getToken(receverID){
    return  FirebaseFirestore.instance.collection('users').doc(receverID).get();
  }
 Stream<QuerySnapshot> getUsers(){
    return  FirebaseFirestore.instance.collection('users').snapshots();
  }
  currentUser(){
   return FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid
    ).get();
  }
}