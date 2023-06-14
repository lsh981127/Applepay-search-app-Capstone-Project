import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newcapstone/community/components/custom_elevated_button.dart';
import 'package:newcapstone/community/components/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../community/profile.dart';

class BusinessPage extends StatefulWidget{
  @override
  _BusinessPageState createState()=>_BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage>{
  final _formKey = GlobalKey<FormState>();
  var userName="";

  final _numberTextEditController=TextEditingController();
  final _nameTextEditController=TextEditingController();
  final _addressTextEditController=TextEditingController();

  @override
  void dispose(){
    _numberTextEditController.dispose();
    _nameTextEditController.dispose();
    _addressTextEditController.dispose();
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
                hint: "사업자등록번호",
                controller: _numberTextEditController,
              ),
              CustomTextFormField(
                hint: "매장명",
                controller: _nameTextEditController,
              ),
              CustomTextFormField(
                hint: "매장 주소",
                controller: _addressTextEditController,
              ),
              CustomElevatedButton(
                  text: "글쓰기 완료",
                  getData:(){
                    final String num=_numberTextEditController.text;
                    final String name=_nameTextEditController.text;
                    final String address=_addressTextEditController.text;
                    final user=userName;

                    final userCollectionReference=
                    FirebaseFirestore.instance.collection("users").doc('${FirebaseAuth.instance.currentUser?.uid}').collection('business').doc(name);
                    userCollectionReference.set({
                      "number":num,
                      "name":name,
                      "address": address,
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
