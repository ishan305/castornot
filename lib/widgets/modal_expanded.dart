import 'package:flutter/material.dart';

showSimpleModalDialog(context, List<Widget> children){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(20.0)),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 350),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        );
      });
}