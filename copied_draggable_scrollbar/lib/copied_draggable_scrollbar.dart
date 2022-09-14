import 'dart:async';

import 'package:flutter/material.dart';

/// Build the Scroll Thumb and label using the current configuration
typedef Widget ScrollThumbBuilder(
  Color backgroundColor,
  Animation<double> thumbAnimation,
  double height,
);

/// A widget that will display a BoxScrollView with a ScrollThumb that can be dragged
/// for quick navigation of the BoxScrollView.
class DraggableScrollbar extends StatefulWidget {
  /// The view that will be scrolled with the scroll thumb
  final BoxScrollView child;

  /// A function that builds a thumb using the current configuration
  final ScrollThumbBuilder scrollThumbBuilder;

  /// The height of the scroll thumb
  final double heightScrollThumb;

  /// The background color of the label and thumb
  final Color backgroundColor;

  /// Determines how quickly the scrollbar will animate in and out
  final Duration scrollbarAnimationDuration;

  /// How long should the thumb be visible before fading out
  final Duration scrollbarTimeToFade;

  /// The ScrollController for the BoxScrollView
  final ScrollController controller;

  final double topPadding;

  DraggableScrollbar({
    Key? key,
    required this.heightScrollThumb,
    required this.backgroundColor,
    required this.scrollThumbBuilder,
    required this.child,
    required this.controller,
    this.topPadding = 0.0,
    this.scrollbarAnimationDuration = const Duration(milliseconds: 300),
    this.scrollbarTimeToFade = const Duration(milliseconds: 600),
  })  : assert(child.scrollDirection == Axis.vertical),
        super(key: key);

  @override
  _DraggableScrollbarState createState() => _DraggableScrollbarState();
}

class _DraggableScrollbarState extends State<DraggableScrollbar>
    with SingleTickerProviderStateMixin {
  double _barOffset = 0.0;
  double _viewOffset = 0.0;
  bool _isDragInProcess = false;

  late AnimationController _thumbAnimationController;
  late Animation<double> _thumbAnimation;
  Timer? _fadeoutTimer;

  @override
  void initState() {
    super.initState();

    _thumbAnimationController = AnimationController(
      vsync: this,
      duration: widget.scrollbarAnimationDuration,
    );

    _thumbAnimation = CurvedAnimation(
      parent: _thumbAnimationController,
      curve: Curves.fastOutSlowIn,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewMaxScrollExtent > 0.0 && controller.initialScrollOffset > 0.0) {
        _initOffsetForScrollInitialOffset();
      }
    });
  }

  void _initOffsetForScrollInitialOffset() {
    _viewOffset = controller.initialScrollOffset;
    setState(() {
      _barOffset = _viewOffset / viewMaxScrollExtent * barMaxScrollExtent;
    });
  }

  @override
  void dispose() {
    _thumbAnimationController.dispose();
    _fadeoutTimer?.cancel();
    super.dispose();
  }

  ScrollController get controller => widget.controller;

  double get barMaxScrollExtent {
    return context.size!.height - widget.heightScrollThumb - widget.topPadding;
  }

  double get barMinScrollExtent => 0.0;

  double get viewMaxScrollExtent => controller.position.maxScrollExtent;

  double get viewMinScrollExtent => controller.position.minScrollExtent;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: changePosition,
      child: Stack(
        children: <Widget>[
          RepaintBoundary(
            child: widget.child,
          ),
          RepaintBoundary(
            child: GestureDetector(
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: _barOffset + widget.topPadding),
                child: widget.scrollThumbBuilder(
                  widget.backgroundColor,
                  _thumbAnimation,
                  widget.heightScrollThumb,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //scroll bar has received notification that it's view was scrolled
  //so it should also changes his position
  //but only if it isn't dragged
  bool changePosition(ScrollNotification notification) {
    final AxisDirection axisDirection = notification.metrics.axisDirection;
    final bool isDown = axisDirection == AxisDirection.down;

    if (!_isDragInProcess && !notification.metrics.outOfRange && isDown) {
      if (notification is ScrollStartNotification) {
        _fadeoutTimer?.cancel();
        _thumbAnimationController.forward();
      }

      if (notification is ScrollUpdateNotification) {
        final double updateAmount = getBarDelta(notification.scrollDelta!);
        updateBarOffset(updateAmount);
      }

      if (notification is ScrollEndNotification) {
        setFadeTimer();
      }
    }
    return true;
  }

  void setFadeTimer() {
    _fadeoutTimer?.cancel();
    _fadeoutTimer = Timer(widget.scrollbarTimeToFade, () {
      _thumbAnimationController.reverse();
      _fadeoutTimer = null;
    });
  }

  void updateBarOffset(double amount) {
    setState(() {
      _barOffset = (_barOffset + amount).clamp(
        barMinScrollExtent,
        barMaxScrollExtent,
      );
    });
  }

  double getBarDelta(double scrollViewDelta) {
    return scrollViewDelta * barMaxScrollExtent / viewMaxScrollExtent;
  }

  double getScrollViewDelta(double barDelta) {
    return barDelta * viewMaxScrollExtent / barMaxScrollExtent;
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _isDragInProcess = true;
    _fadeoutTimer?.cancel();
    _thumbAnimationController.forward();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    updateBarOffset(details.delta.dy);

    final double viewDelta = getScrollViewDelta(details.delta.dy);
    final double newViewOffset = controller.position.pixels + viewDelta;
    _viewOffset = newViewOffset.clamp(viewMinScrollExtent, viewMaxScrollExtent);

    controller.jumpTo(_viewOffset);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setFadeTimer();
    _isDragInProcess = false;
  }
}
