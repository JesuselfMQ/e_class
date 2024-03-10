import 'package:flutter/material.dart';

class WidgetBuilder extends StatefulWidget {

  late final String identifier;

  late final String imageAddress;

  late final double horizontalAlignment;

  late final double verticalAlignment;

  late final double blockHorizontal;

  late final double blockVertical;

  late final double horizontalScaleFactor;

  late final double verticalScaleFactor;

  WidgetBuilder.boxDecoration(String identifier,String imageAddress){
    this.identifier = identifier;
    this.imageAddress = imageAddress;
  }

  WidgetBuilder.image(String identifier,String imageAddress,) {
    
  }

  @override
  State<WidgetBuilder> createState() => _WidgetBuilderState();
}

class _WidgetBuilderState extends State<WidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}