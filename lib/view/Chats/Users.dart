import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterappaes/Model/Users.dart';
import 'package:flutterappaes/services/Firestore.dart';
import 'package:flutterappaes/view/LogIn/login.dart';
import 'package:flutterappaes/view/Profile.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../ChatPage/MainChat.dart';
class UsersShow extends StatefulWidget {
  @override
  _UsersShowState createState() => _UsersShowState();
}

class _UsersShowState extends State<UsersShow> {
  Firestore _firestore=Firestore();


  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("theme", value);
    print('Switch Value saved $value');
    urlinfo();
    return prefs.setBool("theme", value);
  }

  String name='';
  String imageurl='';
var userinfo=FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  @override
  void initState() {
    urlinfo();
    nameinfo();
    // TODO: implement initState
    super.initState();

  }
  String urlinfo(){
    userinfo.then((value){ setState(() {
      imageurl=value.data()!['urlimage'].toString();
      imageurl=   imageurl.split('File:')[1].toString();
      imageurl=   imageurl.trim().toString();
      imageurl=   imageurl.split('\'')[1].toString();
    });});
    return '';
  }
     nameinfo(){
      setState(() {
        userinfo.then((value){ setState(() {
          name=value.data()!['username'].toString();
        }
        );});
      });
    }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle=TextStyle(
        color: Theme.of(context).secondaryHeaderColor,
        fontSize: 22
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
  floatingActionButton: FloatingActionButton(
    backgroundColor:  Theme.of(context).primaryColor,
    child:     Icon(Icons.logout,size: 30,color: Theme.of(context).secondaryHeaderColor,),
        onPressed: ()async{
          FirebaseAuth.instance.signOut();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("Login",false)!=false;
          Navigator.push(context,
              MaterialPageRoute(builder: (_)=>LoginScreen()));
        },
  ),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [],
        leading: Container(),
        centerTitle: true,
        title: Text('Chats',style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 22
        ),),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream:_firestore.getUsers() ,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading"));
            }
            UserModel currentuser=UserModel();
            List<UserModel> users=[];
            for(var i in snapshot.data!.docs){
              if(i['id']==FirebaseAuth.instance.currentUser!.uid) {
                currentuser = UserModel(
                    username: i['username'],
                    id: i['id'],
                    urlimage: i['urlimage'],
                    phonenumber: i['phonenumber'],
                    receverToken:i['receverToken']
                );
                imageurl=i['urlimage'];
                name= i['username'];
              }
              else{
                users.add(UserModel(
                    username: i['username'],
                    id: i['id'],
                    urlimage: i['urlimage'],
                    phonenumber: i['phonenumber'],
                    receverToken:i['receverToken']
                ));
              }
            }
            return new ListView.builder(
              itemCount: users.length,
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        chatPage(freind: users[index], currentUser: currentuser)));
                  },
                  child: new ListTile(
                    leading:  Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:ExactAssetImage(
                                  'asset/images/Logo/logo.png'
                              )
                          )
                      ),
                    ),
                    title: new Text(users[index].username,style: textStyle,),
                    subtitle: new Text(users[index].phonenumber,style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 15
                    ),),
                  ),
                );
              }
            );
          },
        ),
      ),
    );
  }
}