import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:reminder/models/user.dart';
import 'package:reminder/services/auth.dart';


class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home>{
  AuthService _auth = AuthService();
  bool loading = false;
  GlobalKey<FormState> valid = GlobalKey<FormState>();
  bool clear = false;

  @override
  Widget build(BuildContext context) {
    String activity, email, status ;
    Timestamp deadline;
    String dropdownValue = 'Select Status';


    Future<void> addData(Map<String, dynamic> reminder) async {

      await Firestore.instance
          .collection(_auth.user.uid)
          .add(reminder)
          .then((value) => print(value))
          .catchError((e) {
        print(e);
      });
    }
    bool inputValidation(){
      if(valid.currentState.validate()){
        valid.currentState.save();
        return true;
      }
      else{
        clear = true;
        return false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text('Opus',
            style: TextStyle(
                fontSize: 30.0)
        ),
        backgroundColor: Colors.deepPurple[400],
        elevation: 0.0,
        actions: <Widget>[
           FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),


        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Form(
          key: valid,
          autovalidate: clear,
          child: Column(
            children: [
              TextFormField(
                enableSuggestions: true,
                decoration: InputDecoration(
                  labelText: "Activity Title",
                ),
                validator: (val) => (val.length > 0)?
                null : 'Min words: 1',
                onSaved: (val) => activity = val,
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(

                  onPressed: () {

                    DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,

                        minTime: DateTime.now(),
                        onChanged: (dateTime) {
                          deadline = Timestamp.fromDate(dateTime);
                        },
                        currentTime: DateTime.now());
                    print(deadline);
                  },
                  child: Text(
                    'Fix Deadline',
                    style: TextStyle(color: Colors.orange),)
              ),
              DropdownButton<String>(
                items: <String>[
                  'Not Started',
                  'In Progress',
                  'Completed',
                  'Accomplished']
                    .map<DropdownMenuItem<String>>((String col) {
                  return DropdownMenuItem<String>(
                    value: col,
                    child: Text(col),
                  );
                }).toList(),
                icon: Icon(Icons.arrow_downward),
                iconSize: 15,
                hint: Text('Select Completion Status'),
                onChanged: (String dropValue) {
                  setState(() {
                    status = dropValue;
                    print(status);
                    new Text(status);

                  });
                },
                value: status,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              if(inputValidation()) {
                                FirebaseAuth.instance
                                    .currentUser().then((value){
                                  email = value.email;
                                });
                                Map<String, dynamic> reminder = {
                                  "email": email,
                                  "activity": activity,
                                  "status": status,
                                  "deadline": deadline,
                                };
                                addData(reminder);
                              }
                            },
                            child: Column(
                                children: [
                                  SizedBox(height: 12.0),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFF18D191),
                                        borderRadius: BorderRadius.circular(10.0)),
                                    width: double.maxFinite,
                                    margin: EdgeInsets.all(10.0),
                                    padding: EdgeInsets.all(15.0),
                                    child: Center(
                                      child: Text(
                                        "Confirm Task ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                        )
                    ),
                  ]
              ),

            ],

          ),
        ),
      ),
    );

  }
}










