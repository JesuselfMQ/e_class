import 'package:flutter/material.dart';

class WidgetBuilder {

  BoxDecoration getBackground(String imageAddress) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imageAddress),
        fit: BoxFit.fill,
      ),
    );
  }

  Align getImageButton(String imageAddress,
    double horizontalAlignment,
    double verticalAlignment,
    double blockhorizontal,
    double blockvertical,
    double horizontalScaleFactor,
    double verticalScaleFactor,
    {VoidCallback? onSelected}) {
    if(onSelected != null) {
      return Align(
        alignment: Alignment(horizontalAlignment, verticalAlignment),
        child: IconButton(
          onPressed: onSelected,
          icon: Image.asset(
            imageAddress,
            width: blockhorizontal * horizontalScaleFactor,
            height: blockvertical * verticalScaleFactor,
          )
        )
      ); 
    }
    return Align(
      alignment: Alignment(horizontalAlignment, verticalAlignment),
      child: Image.asset(
        imageAddress,
        width: blockhorizontal * horizontalScaleFactor,
        height: blockvertical * verticalScaleFactor
      ),
    );
  }

}
