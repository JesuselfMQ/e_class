import 'package:flutter/material.dart';

/// A widget that makes it easy to create a screen with a square-ish
/// main area and a smaller menu area.
/// It works in both orientations on mobile- and tablet-sized screens.
class ResponsiveScreen extends StatelessWidget {
  /// This is the "hero" of the screen. It's more or less square, and will
  /// be placed in the visual "center" of the screen.
  final Widget squarishMainArea;

  /// The second-largest area after [squarishMainArea]. It can be narrow
  /// or wide.
  final Widget rectangularMenuArea;

  const ResponsiveScreen({
    required this.squarishMainArea,
    required this.rectangularMenuArea,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      // This widget wants to fill the whole screen.
      final size = constraints.biggest;
      // Divide the shortest side of the widget's size by 30 to determine the amount of padding.
      final padding = EdgeInsets.all(size.shortestSide / 30);

      if (size.height >= size.width) {
        // "Portrait" / "mobile" mode.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: padding,
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                minimum: padding,
                child: squarishMainArea,
              ),
            ),
            SafeArea(
              top: false,
              maintainBottomViewPadding: true,
              child: Padding(
                padding: padding,
                child: Center(
                  child: rectangularMenuArea,
                ),
              ),
            ),
          ],
        );
      } else {
        // "Landscape" / "tablet" mode.
        final isLarge = size.width > 900;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: isLarge ? 7 : 5,
              child: SafeArea(
                right: false,
                maintainBottomViewPadding: true,
                minimum: padding,
                child: squarishMainArea,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    left: false,
                    maintainBottomViewPadding: true,
                    child: Padding(
                      padding: padding,
                    ),
                  ),
                  Expanded(
                    child: SafeArea(
                      top: false,
                      left: false,
                      maintainBottomViewPadding: true,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: padding,
                          child: rectangularMenuArea,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }
    });
  }
}
