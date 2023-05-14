import 'dart:async';

import 'package:flutter/widgets.dart';

class CustomTap extends StatefulWidget {
  // child: your widget that you want to put the zoom effect on.
  final Widget child;

  // begin: the size of widget you want to begin with.
  // end: the size of widget you want to end with.
  final double begin, end;

  // beginDuration: the duration of the begin zoom in animation.
  // endDuration: the duration of the end zoom in animation.
  // longTapRepeatDuration: the duration between every onTap/onLongTap loop event.
  final Duration beginDuration, endDuration, longTapRepeatDuration;

  // onTap: what should happen when you tap on the widget.
  // onLongTap: what should happen when you long tap on the widget.
  final Function()? onTap, onLongTap;

  // enableLongTapRepeatEvent: option to enable long tap loop which repeat every onTap event (in case onLongTap is specified, it repeats the onLongTap event).
  final bool enableLongTapRepeatEvent;

  // beginCurve: the curve animation type of the begin zoom in animation.
  // endCurve: the curve animation type of the end zoom in animation.
  final Curve beginCurve, endCurve;

  const CustomTap(
      {Key? key,
      required this.child,
      this.onTap,
      this.begin = 1.0,
      this.end = 0.95,
      this.beginDuration = const Duration(milliseconds: 20),
      this.endDuration = const Duration(milliseconds: 100),
      this.longTapRepeatDuration = const Duration(milliseconds: 100),
      this.beginCurve = Curves.linear,
      this.endCurve = Curves.linear,
      this.onLongTap,
      this.enableLongTapRepeatEvent = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _CustomTapState();
}

class _CustomTapState extends State<CustomTap>
    with SingleTickerProviderStateMixin<CustomTap> {
  // make AnimationController nullable to make sure to not use it if it's null
  AnimationController? _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // initial AnimationController
    _controller = AnimationController(
        vsync: this,
        duration: widget.endDuration,
        value: 1.0,
        reverseDuration: widget.beginDuration);
    // initial tween animation
    _animation = Tween(begin: widget.end, end: widget.begin).animate(
        CurvedAnimation(
            parent: _controller!,
            curve: widget.beginCurve,
            reverseCurve: widget.endCurve));
    // animate the Tween animation from the begin point to the end point
    _controller?.forward();
  }

  bool _isOnTap = true;
  @override
  Widget build(BuildContext context) {
    Future<void> _onLongPress() async {
      // animate the Tween animation from the begin point to the end point
      await _controller?.forward();
      // call long tap event
      await widget.onLongTap?.call();
    }

    return GestureDetector(
      // call one tap event
      onTap: widget.onTap,
      // call long tap one event if the long tap repeat(loop) is false
      onLongPress: widget.onLongTap != null && !widget.enableLongTapRepeatEvent
          ? _onLongPress
          : null,
      child: Listener(
          onPointerDown: (c) async {
            // prevent the onTap event from beign triggered
            _isOnTap = true;
            // animate the Tween animation from the end point to the start point
            _controller?.reverse();
            // check if long tap loop is true
            if (widget.enableLongTapRepeatEvent) {
              // the duration before starting the loop event
              await Future.delayed(widget.longTapRepeatDuration);
              // _isOnTap is to check that the tap is still down (check onPoRobotoUp method which assign _isOnTap to false)
              while (_isOnTap)
                // the duration between every onTap/onLongTap loop event.
                await Future.delayed(widget.longTapRepeatDuration, () async {
                  // call onTap if onLongTap is not specified
                  await (widget.onLongTap ?? widget.onTap)?.call();
                });
            }
          },
          onPointerUp: (c) async {
            // prevent the onTap event from beign triggered if the user has taped the widget for more than than 150 milliseconds
            _isOnTap = false;
            // animate the Tween animation from the begin point to the end point
            await _controller?.forward();
          },
          child: ScaleTransition(scale: _animation, child: widget.child)),
    );
  }

  @override
  void dispose() {
    // stop the running animation in the state
    _controller?.stop();
    _controller?.dispose();
    // assign AnimationController to null to make sure it's won't be used
    _controller = null;
    super.dispose();
  }
}
