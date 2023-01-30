import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappaes/Helper/Push_Notification.dart';
import 'package:flutterappaes/Model/Users.dart';
import 'package:flutterappaes/services/Firestore.dart';
import '../Chats/Users.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class useiInfo extends StatefulWidget {
  var phonenomber,id;
useiInfo({this.id,this.phonenomber});
  @override
  _useiInfoState createState() => _useiInfoState();
}

class _useiInfoState extends State<useiInfo> {
  var _image;
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
var username;
  bool? login=false;
  Firestore _firestore=Firestore();
  FirebaseNotifcation? fN;
  var token;
  @override
  void initState() {
    super.initState();
    fN=FirebaseNotifcation();
    setState(() {
      handleAsync();
    });
  }
  handleAsync() async {
    String? _token = await fN!.getToken();
    setState(() {
      token=_token;
    });
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Theme.of(context).backgroundColor,
      appBar:  AppBar(
        centerTitle: true,
        title: Text('User Info',style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 22
        ),),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/9,),
            GestureDetector(
            child:_image==null?CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 60,
              child: Icon(Icons.camera_alt,size:60),
            ):CircleAvatar(
              backgroundImage: FileImage(_image),
              radius: 60,
            ),
              onTap: (){
                getImage();
              },
            ),
            SizedBox(height: 20,),
            TextField(

              onChanged: (value){
                setState(() {
                  username=value;
                });
              },
              decoration: InputDecoration(

                  labelText: " User name",
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    )
                ),
                enabledBorder: OutlineInputBorder( //Outline border type for TextFeild
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    )),
                hintText: '  user name',
                icon: Icon(Icons.person,color:Theme.of(context).primaryColor)
              ),
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,

                  borderRadius: BorderRadius.circular(50)
              ),
              width: 200,
              height: 75,
              child: FlatButton(
                child: Text('Submit',style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Theme.of(context).secondaryHeaderColor
                ),),
                onPressed: ()async{
                    Firestore firestore = Firestore();
                    UserModel user=
                UserModel(id: widget.id,urlimage: _image.toString(),phonenumber: widget.phonenomber,username: username);
                    firestore.addUsers(
                        UserModel(
                            username: username,
                            phonenumber: widget.phonenomber,
                            id: widget.id,
                            urlimage: _image.toString(),
                          receverToken: token.toString()
                        )
                    );
                    if(widget.id!=null&&_image!=null&&widget.phonenomber!=null&&username!=null) {
                      setState(() {
                        login=true;
                      });
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('Login',  login!);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UsersShow()));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('you should complete your data'),
                        duration: const Duration(seconds: 10),
                      ));
                    }
                },
              ),
            )
          ],
        )
      ),
    );
  }
}