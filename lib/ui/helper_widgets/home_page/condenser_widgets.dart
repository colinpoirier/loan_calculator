import 'package:flutter/material.dart';

class Scroller extends SingleChildScrollView {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics physics;

  Scroller.column({
    this.children,
    this.padding,
    this.physics
  }) : super(
          padding: padding,
          child: Column(
            children: children,
          ),
        );

  Scroller.row({
    this.children,
    this.padding,
    this.physics
  }) : super(
          physics: physics ?? NeverScrollableScrollPhysics(),
          child: Row(
            children: children,
          ),
          scrollDirection: Axis.horizontal,
        );

  Scroller.stack({
    this.children,
    this.padding,
    this.physics
  }) : super(
          child: Stack(
            children: children,
            alignment: Alignment.center,
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

class ExpandedListViewStack extends Expanded {
  final int itemCount;
  final Function(BuildContext, int) itemBuilder;
  final Widget positionedDecoration;
  final Widget bottomDecoration;
  final EdgeInsets padding;

  ExpandedListViewStack({
    this.itemCount,
    this.itemBuilder,
    this.positionedDecoration,
    this.bottomDecoration,
    this.padding
  }) : super(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: padding,
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
              positionedDecoration,
              // bottomDecoration,
            ],
          ),
        );
}

class PaddedInkWellColumn extends InkWell {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final List<Widget> children;

  PaddedInkWellColumn({
    this.onTap,
    this.children,
    this.onLongPress,
  }) : super(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: children,
            ),
          ),
        );
}

class SizeScaleTransition extends StatelessWidget {
  const SizeScaleTransition({Key key, this.animation, this.child,}) : super(key: key);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 570,
      ),
      child: SizeTransition(
        sizeFactor: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      ),
    );
  }
}
