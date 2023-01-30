import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappaes/AES/Algorithm_AES.dart';
import 'package:flutterappaes/Helper/Push_Notification.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:video_player/video_player.dart';
sendMsg( textEditingController,groupChatId,currentUser,freind,scrollController,User_id,context,type) {
  var msg = textEditingController;
  /// Upload images to firebase and returns a URL
  if (msg.toString().isNotEmpty){
    print('thisiscalled $msg');
    var ref = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId!)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(ref, {
        "senderId": User_id,
        "anotherUserId": freind.id,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
        'content':   msg,
        'sendername': currentUser.username,
        'recevername':freind.username,
        "type": type,
      });
    });
    scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    FirebaseNotifcation FN=FirebaseNotifcation();
    FN.sendPushMessage(freind.receverToken.toString(), currentUser.username, msg);
    print(currentUser.receverToken.toString());
    FN.initialize(context);
  } else {
    print('Please enter some text to send');
  }
}

buildItem(doc,context,user_ID,_controller) {
  return Padding(
    padding: EdgeInsets.only(
        top: 8.0,
        left: ((doc['senderId'] == user_ID) ?60 : 0),
        right: ((doc['senderId'] == user_ID) ? 0 : 60 )),
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.only(
          left: ((doc['senderId'] == user_ID) ?0 : 8),
          right: ((doc['senderId'] == user_ID) ? 8 : 0 )),
      decoration: BoxDecoration(
          color: ((doc['senderId'] == user_ID)
              ? Color(0xffCBD8E0)
              : Color(0xff8192AE)),
          borderRadius: (doc['senderId'] == user_ID)
              ?BorderRadius.only(bottomRight:Radius.circular(0),topRight:Radius.circular(20) ,topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20)):BorderRadius.only(bottomRight:Radius.circular(20),topRight:Radius.circular(20) ,topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(0))),
      child: (doc['type'] == 'image')
          ?
               Container(
                width: 60,height: 150,
                decoration: BoxDecoration(
                ),
                child: Image( image: FileImage(File(MyEncryptionDecryption.decryp(doc['content'].toString())),),fit: BoxFit.cover,),
              ): doc['type'] == 'vedio'?
                Container(
                width: 60,height: 130,
                decoration: BoxDecoration(
                ),
                child: Stack(
                  fit:StackFit.expand,
                  children: [
                _controller.value.isInitialized
                ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),

                  Center(child: IconButton( onPressed: () {
                    _controller!.play();

//        setState(() {
//          _controller.value.isPlaying
//              ? _controller.pause()
//              : _controller.play();
//        });
      }, icon: Icon((Icons.play_circle_filled),size: 60,)))
                ],)
              ): doc['type'] == 'text'?  Text('${MyEncryptionDecryption.decryp(doc['content'])}',style: TextStyle(color: Colors.black,fontSize: 20,),)
         :Text('') ,
    ),
  );
}
