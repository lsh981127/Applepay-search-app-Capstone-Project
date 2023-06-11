import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newcapstone/community/components/custom_elevated_button.dart';
import 'package:newcapstone/community/components/custom_textarea.dart';
import 'package:newcapstone/community/components/custom_text_form_field.dart';
import 'package:newcapstone/community/freeforum.dart';

import 'components/custom_text_form_field.dart';

class WritePage extends StatelessWidget {
  
  final _formKey = GlobalKey<FormState>();

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
                  CustomTextFormField(hint: "Title", funValidator: (value) {}),
                  const CustomTextArea(hint: "Content"),
                  CustomElevatedButton(
                      text: "글쓰기 완료",
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