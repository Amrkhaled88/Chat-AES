import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterappaes/AES/Algorithm_AES.dart';
import 'package:flutterappaes/Model/Users.dart';
import 'package:flutterappaes/view/ChatPage/chatPageHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
class chatPage extends StatefulWidget {
  UserModel freind,currentUser;
  chatPage({required this.freind,required this.currentUser});
  @override
  _ChatPageState createState() => _ChatPageState();
}
class _ChatPageState extends State<chatPage> {
  var encryptedText;
   String? groupChatId;
   String? user_ID;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  VideoPlayerController? _controller;
    ctrVedioPlayer(){
      _controller = VideoPlayerController.file(
          File('$_image'))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  @override
  void initState() {
    super.initState();
      ctrVedioPlayer();
    FirebaseMessaging.onMessage.listen(( message) {
      print('${message.data['title']} + ${message.notification!.body}');
    });

    getGroupChatId();
    super.initState();
  }


  getGroupChatId() async {
    String anotherUserId = widget.freind.id;
    user_ID=widget.currentUser.id;

    if (user_ID!.compareTo(anotherUserId) > 0) {
      groupChatId = '$user_ID - $anotherUserId';
    } else {
      groupChatId = '$anotherUserId - $user_ID';
    }
    setState(() {
    });
  }

  bool vedioCHeck=false;
  bool imageCheck=false;
  var _image ;
  var imageurl='';
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  Future<void> getVedio() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  var contant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.freind.username}',style: TextStyle(
            fontSize: 22,
            color: Theme.of(context).secondaryHeaderColor),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId!)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemBuilder: (listContext, index){
                        return
                        buildItem(snapshot.data!.docs[index],context,user_ID,_controller);},
                        itemCount: snapshot.data!.docs.length,
                        reverse: true,
                        )),
                        Row(
                        children: <Widget>[
                        Expanded(
                        child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                        hintText: '  Send message',
                        hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).secondaryHeaderColor
                        )
                        ),
                        ),
                        ),
                          IconButton(
                            icon: Icon(
                                Icons.image,color: Theme.of(context).primaryColor
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text("choose from gallery"),

                                    actions: <Widget>[
                                    Row(
                                      children: [
                                        new FlatButton(
                                          child: new Icon(Icons.image,size: 100,color: Theme.of(context).primaryColor,),
                                          onPressed: () {
                                            getImage();
                                            imageCheck=true;

                                          }),




                                        new FlatButton(
                                          child: new Icon(Icons.play_circle_outline,size: 100,color: Theme.of(context).primaryColor,),
                                          onPressed: () {
                                            getVedio();
                                            vedioCHeck=true;
                                            setState(() {
                                              ctrVedioPlayer();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: FlatButton(
                                          child: new Text('done',style:
                                          TextStyle(color: Colors.blue,decoration: TextDecoration.underline,fontSize: 18),),
                                          onPressed: () {
                                            setState(() {
                                              imageurl=_image.toString();
                                              imageurl=   imageurl.split('File:')[1];
                                              imageurl=   imageurl.trim();
                                              imageurl=   imageurl.split('\'')[1];
                                              print(imageurl.toString());
                                              imageurl= MyEncryptionDecryption.encryp(imageurl);
                                            });
                                            print(imageurl.toString());

                                            setState(() {
                                              sendMsg(
                                                  imageurl,
                                                  groupChatId,
                                                  widget.currentUser,
                                                  widget.freind,
                                                  scrollController,
                                                  user_ID,
                                                  context,imageCheck==true?'image':'vedio');
                                            });
                                            print(_image.toString());

                                            Navigator.of(context).pop();
                                          },

                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        IconButton(
                        icon: Icon(
                        Icons.send,color: Theme.of(context).primaryColor
                      ),
                      onPressed: () {
                        setState(() {
                          encryptedText=
                              MyEncryptionDecryption.encryp(textEditingController.text);
                        });
                        imageCheck=false;vedioCHeck=false;
                        sendMsg(encryptedText,groupChatId,widget.currentUser,widget.freind,scrollController,user_ID,context,'text');

                      },
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ));
          }
        },
      ),
    );
  }
}