import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget{

  final String text;
  final funPageRoute;
  final getData;

  const CustomElevatedButton({required this.text, required this.funPageRoute, required this.getData});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
          funPageRoute();
          getData();
        },
      child: Text("$text"),
    );
  }
}
