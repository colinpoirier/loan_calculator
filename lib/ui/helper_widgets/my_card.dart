import 'package:flutter/material.dart';

class MyCard extends StatelessWidget{

  const MyCard({
    Key key,
    this.elevation = 4.0,
    this.margin = const EdgeInsets.all(10.0),
    this.child,
  }):super(key:key);

  final double elevation;
  final EdgeInsets margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Theme.of(context).primaryColor,
      elevation: elevation,
      margin: margin,
      child: child,
    );
  }
}