import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newcapstone/community/components/custom_elevated_button.dart';
import 'package:newcapstone/community/components/custom_textarea.dart';
import 'package:newcapstone/community/components/custom_text_form_field.dart';
import 'package:newcapstone/community/freeforum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WritePage extends StatefulWidget{
  @override
  _WritePageState createState()=>_WritePageState();
}

class _WritePageState extends State<WritePage>{
  final _formKey = GlobalKey<FormState>();
  final firestore=FirebaseFirestore.instance;

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
                    // user 정보 가져오기
                    // final user=
                    final userCollectionReference=
                      FirebaseFirestore.instance.collection("users").doc('${FirebaseAuth.instance.currentUser?.uid}').collection('myposts').doc(title);
                    userCollectionReference.set({
                      "title":title,
                      "content":content,
                      // "user": ,
                      //날짜+시간: ,
                      //공감수: ,
                      //댓글수: ,
                    });
                    final postCollectionReference=
                    FirebaseFirestore.instance.collection("posts").doc(title);
                    postCollectionReference.set({
                      "title":title,
                      "content":content,
                      // "user": ,
                      //날짜+시간: ,
                      //공감수: ,
                      //댓글수: ,
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
