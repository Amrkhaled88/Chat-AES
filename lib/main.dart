import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterappaes/view/Chats/Users.dart';
import 'package:flutterappaes/view/LogIn/login.dart';
import 'Helper/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/Push_Notification.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseNotifcation firebase=FirebaseNotifcation();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var login= prefs.getBool('Login');
  runApp(MyApp(login,));
}


class MyApp extends StatefulWidget {
  var login;
  MyApp(this.login);
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  FirebaseNotifcation? firebase;
  handleAsync() async {
    await firebase!.initialize(context);
    String? token = await firebase!.getToken();
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    firebase = FirebaseNotifcation();
    firebase!.subscribeToTopic();
    handleAsync();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme:Light_theme,
        // ignore: unrelated_type_equality_checks
        home:widget.login!=true?LoginScreen():UsersShow()
      // widget.login!=true?LoginScreen():UsersShow()Delayed_animation(),
    );
  }}

