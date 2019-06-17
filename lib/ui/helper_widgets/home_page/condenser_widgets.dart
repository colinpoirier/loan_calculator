import 'package:flutter/material.dart';

class Scroller extends SingleChildScrollView {
  final List<Widget> children;

  Scroller.column({
    this.children,
  }) : super(
          child: Column(
            children: children,
          ),
        );

  Scroller.row({
    this.children,
  }) : super(
          child: Row(
            children: children,
          ),
          scrollDirection: Axis.horizontal,
        );

  Scroller.stack({
    this.children,
  }) : super(
          child: Stack(
            children: children,
            alignment: Alignment.topCenter,
          ),
          scrollDirection: Axis.horizontal,
        );
}

class DataContainer extends Container {
  final Widget topChild;
  final Widget bottomChild;
  final VoidCallback ontap;

  DataContainer({
    this.topChild,
    this.bottomChild,
    this.ontap,
  }) : super(
          height: 55,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: topChild,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: ontap,
                    child: bottomChild,
                  ),
                ),
              ),
            ],
          ),
        );
}

class ScaleSwitcher extends AnimatedSwitcher {
  final Duration duration;
  final Widget child;

  ScaleSwitcher({
    @required this.duration,
    this.child,
  }) : super(
          duration: duration,
          switchInCurve: Curves.fastOutSlowIn,
          switchOutCurve: const Interval(
            0.9,
            1.0,
            curve: Curves.easeInQuint,
          ),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              alignment: Alignment.topCenter,
              scale: animation,
              child: child,
            );
          },
          child: child,
        );
}

class ExpandedListView extends Expanded{
  final int itemCount;
  final Function(BuildContext, int) itemBuilder;

  ExpandedListView({this.itemCount, this.itemBuilder}):super(
    child: ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    )
  );
}

class PaddedInkWellColumn extends InkWell{
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final List<Widget> children;

  PaddedInkWellColumn({this.onTap, this.children, this.onLongPress}):super(
    onTap: onTap,
    onLongPress: onLongPress,
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: children,
      ),
    )
  );
}
