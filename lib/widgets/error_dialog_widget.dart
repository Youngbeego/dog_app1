
import 'package:dog_app/exceptions/custom_exception.dart';
import 'package:flutter/material.dart';

void errorDialogWidget(BuildContext context,CustomException e){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          title: Text(e.code),
          content: Text(e.message),
          actions: [
            TextButton(
                onPressed: ()=>Navigator.pop(context),
                child: Text('확인'),
            )
          ],
        );
      },
  );
}