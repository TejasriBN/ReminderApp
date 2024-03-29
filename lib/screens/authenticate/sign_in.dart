import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reminder/services/auth.dart';
import 'package:reminder/shared/constants.dart';
import 'package:reminder/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  GoogleSignIn googleAuth = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,

        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 60),

          child: Container(

            //padding: EdgeInsets.only(top: 30),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration:InputDecoration(
                      labelText: 'Email',
                      //labelStyle: f
                    ),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration:InputDecoration(
                      labelText: 'Password',

                    ),
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 25.0),
                  RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                      ),
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white,fontSize: 20),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if(result == null) {
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      }
                  ),
                  SizedBox(height: 50.0),
                  RaisedButton(
                    onPressed: (){
                      // googleAuth.signIn().then((result){
                      //   result.authentication.then((googleKey){
                      //     FirebaseAuth.instance
                      //         .signInWithCredential(
                      //         GoogleAuthProvider
                      //             .credential(
                      //               idToken: googleKey.idToken,
                      //               accessToken: googleKey.accessToken))
                      //             .then((signedInUser){
                      //               Navigator.of(context).pushReplacementNamed('/home');
                      //     }).catchError((e){
                      //       print(e);
                      //     });
                      //   }).catchError((e){
                      //     print(e);
                      //   });
                      // }).catchError((e){
                      //   print(e);
                      // });
                    },

                    color: Color(0XFFDF513C),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
                    ),
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.white
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Google",
                          style: TextStyle(color: Colors.white,fontSize: 20),

                        )
                      ],
                    ),
                  ),
                  Row(
                      children: [
                        Padding(padding: EdgeInsets.all(25.0)),
                        Text("Don't have an Account? "),
                        GestureDetector(
                            onTap: () => widget.toggleView(),
                            child: Text("Sign Up",
                                style: TextStyle(

                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline
                                )
                            )
                        )
                      ]
                  ),

                ],
              ),
            ),
          ),
        )
    );
  }
}