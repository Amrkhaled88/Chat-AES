import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'User_info.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();


  @override
  Widget build(BuildContext context){
   BoxDecoration pinPutDecoration = BoxDecoration(
      color:Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: const Color.fromRGBO(126, 203, 224, 1),
      ));
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldkey,
      body: Column(
        children: [
          Container(
            width:MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height/2.5,
            margin: EdgeInsets.only(top: 10),
           decoration: BoxDecoration(
             image: DecorationImage(
               image: ExactAssetImage('asset/images/verfiy.png')
             )
           ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(
              child: Text(

                'Enter the 6-digits code sent to your phone number ${widget.phone}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,color: Theme.of(context).secondaryHeaderColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle:  TextStyle(fontSize: 25.0, color: Theme.of(context).secondaryHeaderColor),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => useiInfo(
                            phonenomber: widget.phone,
                            id: FirebaseAuth.instance.currentUser!.uid,
                          )),
                          (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState!
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    Firebase.initializeApp();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => useiInfo(
                    phonenomber: widget.phone,
                    id: FirebaseAuth.instance.currentUser!.uid,
                  )),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },

        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
          return;
        },

        timeout: Duration(seconds: 120),
        codeSent: (String verficationID, int? forceResendingToken) {
      setState(() {
        _verificationCode = verficationID;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _verifyPhone();

  }
}
