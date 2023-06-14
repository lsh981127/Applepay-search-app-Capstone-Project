import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newcapstone/community/components/custom_elevated_button.dart';
import 'package:newcapstone/community/components/custom_textarea.dart';
import 'package:newcapstone/community/components/custom_text_form_field.dart';
import 'package:newcapstone/community/freeforum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WritePage extends StatefulWidget{
  @override
  _WritePageState createState()=>_WritePageState();
}

class _WritePageState extends State<WritePage>{
  final _formKey = GlobalKey<FormState>();
  var userName="";

  final _titleTextEditController=TextEditingController();
  final _contentTextEditController=TextEditingController();

  @override
  void dispose(){
    _titleTextEditController.dispose();
    _contentTextEditController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    final userCollectionReference = FirebaseFirestore.instance
        .collection("users")
        .doc('${FirebaseAuth.instance.currentUser?.uid}')
        .get();

    final data = await userCollectionReference;
    final name = (data.data()?["nickname"].toString() ?? "");

    setState(() {
      userName=name;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                  hint: "Title",
                  controller: _titleTextEditController,
              ),
              CustomTextArea(
                  hint: "Content",
                  controller:_contentTextEditController,
              ),
              CustomElevatedButton(
                  text: "글쓰기 완료",
                  getData:(){
                    final String title=_titleTextEditController.text;
                    final content=_contentTextEditController.text;
                    final user=userName;

                    DateTime dt = DateTime.now();
                    final date=DateFormat('MM/dd').format(dt);
                    final time=DateFormat('HH:mm').format(dt);


                    // final userCollectionReference=
                    //   FirebaseFirestore.instance.collection("users").doc('${FirebaseAuth.instance.currentUser?.uid}').collection('myposts').doc(title);
                    // userCollectionReference.set({
                    //   "title":_titleTextEditController.text,
                    //   "content":_contentTextEditController.text,
                    //   "writer": user,
                    //   "date":date,
                    //   "time":time,
                    //   "like":0,
                    //   "comment":0,
                    // });
                    final postCollectionReference=
                    FirebaseFirestore.instance.collection("posts").doc(title);
                    postCollectionReference.set({
                      "title":title,
                      "content":content,
                      "writer": user,
                      "date":date,
                      "time":time,
                      "like":0,
                      "comment":0,
                    });
                  },
                  funPageRoute: () {
                    if(_formKey.currentState!.validate()){
                      Get.off(freeForum());
                    }
                  }
              )],
          ),
        ),
      ),
    );
  }
}
