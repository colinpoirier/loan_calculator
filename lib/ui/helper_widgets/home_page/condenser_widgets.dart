import 'package:flutter/material.dart';
import 'package:loan_calc_dev/state_management/final_notifier/final_notifier.dart';
import 'package:provider/provider.dart';

class Scroller extends SingleChildScrollView {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  Scroller.column({required this.children, this.padding, this.physics})
      : super(
          padding: padding,
          child: Column(
            children: children,
          ),
        );

  Scroller.row({required this.children, this.padding, this.physics})
      : super(
          physics: physics ?? NeverScrollableScrollPhysics(),
          child: Row(
            children: children,
          ),
          scrollDirection: Axis.horizontal,
        );

  Scroller.stack({required this.children, this.padding, this.physics})
      : super(
          child: Stack(
            children: children,
            alignment: Alignment.center,
          ),
          scrollDirection: Axis.horizontal,
        );
}

class DataContainer extends StatelessWidget {
  DataContainer({
    required this.topChild,
    required this.bottomChild,
    required this.ontap,
  });

  final Widget topChild;
  final Widget bottomChild;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: NavButton(
                onPressed: ontap,
                icon: bottomChild,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  NavButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final enabled = context.select<FinalNotifier, bool>((fn) => !fn.state.isEditing);
    return IconButton(
      icon: icon,
      onPressed: enabled ? onPressed : null,
    );
  }
}

class ScaleSwitcher extends AnimatedSwitcher {
  final Duration duration;
  final Widget child;

  ScaleSwitcher({
    required this.duration,
    required this.child,
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

class ListViewStack extends StatelessWidget {
  const ListViewStack({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.top,
    required this.padding,
  }) : super(
          key: key,
        );

  final int itemCount;
  final Function(BuildContext, int) itemBuilder;
  final Widget top;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: padding,
          itemCount: itemCount,
          itemBuilder: itemBuilder as Widget Function(BuildContext, int),
        ),
        top,
      ],
    );
  }
}

class PaddedInkWellColumn extends InkWell {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<Widget> children;

  PaddedInkWellColumn({
    this.onTap,
    required this.children,
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
  const SizeScaleTransition({
    Key? key,
    this.animation,
    this.child,
  }) : super(key: key);

  final Animation<double>? animation;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 570,
      ),
      child: SizeTransition(
        sizeFactor: animation!,
        child: ScaleTransition(
          scale: animation!,
          child: child,
        ),
      ),
    );
  }
}
