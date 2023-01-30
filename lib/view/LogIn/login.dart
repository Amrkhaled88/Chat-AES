

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'otp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  var country_code='20';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: Center(),
        actions: [ Center()],

        centerTitle: true,
        title: Text('Phone Auth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            // Container(
            //   margin: EdgeInsets.only(top: 60),
            //   child: Center(
            //     child: Text(
            //       'Phone Authentication',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28,color: Theme.of(context).secondaryHeaderColor),
            //     ),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(

                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
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
                  border: InputBorder.none,
                  hintText: "Phone Number",
                  hintStyle:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor
                    ),
                  prefixStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).secondaryHeaderColor
                  ),

                  prefix: CountryPickerDropdown(
                    iconDisabledColor: Theme.of(context).secondaryHeaderColor,
                    iconEnabledColor: Theme.of(context).secondaryHeaderColor,
                    initialValue: 'EG',
                    onValuePicked: (Country country) {
                      setState(() {
                        country_code=country.phoneCode;
                      });
                    },
                  ),
                ),
                onChanged: (value){
                },
                controller: _controller,
              ),
            )
            , Container(
              margin: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  '------ please confirm your country code and enter your phone number',
                  style: TextStyle( fontSize: 18,color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
            ),
          ]),
          Container(
            margin: EdgeInsets.all(10),  decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,

              borderRadius: BorderRadius.circular(50)
          ),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: FlatButton(
              onPressed: () {
                Firebase.initializeApp();
                print(country_code);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OTPScreen('+'+'$country_code'+'${_controller.text}')));
              },
              child: Text(
                'Next',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Theme.of(context).secondaryHeaderColor
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
