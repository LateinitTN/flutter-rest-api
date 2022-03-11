import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future openPage(Widget page, BuildContext context) async{
  final route = CupertinoPageRoute(builder: (BuildContext context) => page);
  return await Navigator.of(context).push(route);
}

Future openPageMaterial(Widget page, BuildContext context) async{
  final route = MaterialPageRoute(builder: (BuildContext context) => page);
  return await Navigator.of(context).push(route);
}

void closePage(BuildContext context){
  Navigator.of(context).pop();
}