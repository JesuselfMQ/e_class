import 'package:flutter/material.dart';

class WidgetBuilder extends StatelessWidget {

  late final String identifier;

  late final String imageAddress;
  
  late final double horizontalAlignment;

  late final double verticalAlignment;

  late final double blockHorizontal;

  late final double blockVertical;

  late final double horizontalScaleFactor;

  late final double verticalScaleFactor;

  late final VoidCallback? onSelected;

  WidgetBuilder.boxDecoration({
    required this.identifier,
    required this.imageAddress,
    super.key
  });

  WidgetBuilder.image({
    required this.identifier,
    required this.imageAddress,
    required this.horizontalAlignment,
    required this.verticalAlignment,
    required this.blockHorizontal,
    required this.blockVertical,
    required this.horizontalScaleFactor,
    required this.verticalScaleFactor,
    super.key
  });

  WidgetBuilder.iconButton({
    required this.identifier,
    required this.imageAddress,
    required this.horizontalAlignment,
    required this.verticalAlignment,
    required this.blockHorizontal,
    required this.blockVertical,
    required this.horizontalScaleFactor,
    required this.verticalScaleFactor,
    required this.onSelected,
    super.key
  });

  BoxDecoration getBackgroundImage(){
    return BoxDecoration();
  }

  @override
  Widget build(BuildContext context) {
    if(identifier == "box_decoration"){
      return Scaffold();
    }
    return Scaffold();
  }
}
