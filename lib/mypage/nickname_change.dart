import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newcapstone/community/components/custom_elevated_button.dart';
import 'package:newcapstone/community/components/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../community/profile.dart';

class NickNameChangePage extends StatefulWidget{
  @override
  _NickNameChangePageState createState()=>_NickNameChangePageState();
}

class _NickNameChangePageState extends State<NickNameChangePage>{
  final _formKey = GlobalKey<FormState>();
  var userName="";

  final _nicknameTextEditController=TextEditingController();

  @override
  void dispose(){
    _nicknameTextEditController.dispose();
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
    final name = (data.data()?["name"].toString() ?? "");

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
                hint: "닉네임",
                controller: _nicknameTextEditController,
              ),
              CustomElevatedButton(
                  text: "글쓰기 완료",
                  getData:(){
                    final String nickname=_nicknameTextEditController.text;
                    final user=userName;

                    final userCollectionReference=
                    FirebaseFirestore.instance.collection("users").doc('${FirebaseAuth.instance.currentUser?.uid}');
                    userCollectionReference.update({
                      "nickname":nickname,
                    });
                  },
                  funPageRoute: () {
                    if(_formKey.currentState!.validate()){
                      Get.off(ProfilePage());
                    }
                  }
              )],
          ),
        ),
      ),
    );
  }
}
