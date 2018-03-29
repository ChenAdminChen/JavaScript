import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hello_world/PagerIndicator.dart';

class PageDragger extends StatefulWidget {
  final StreamController<SlideUpdate> slideUpdateStream;

  final bool canDragLeftToRight;
  final bool canDragRightToLeft;

  PageDragger({
    this.slideUpdateStream,
    this.canDragLeftToRight,
    this.canDragRightToLeft
});

  @override
  _PageDraggerState createState() => new _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {

  static const FULL_TRANSITION_PX = 300.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details){
     dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details){
    if (dragStart !=null) {
      final newPostion = details.globalPosition;
      final dx = dragStart.dx - newPostion.dx;

      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftTORight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      }else{
        slidePercent = 0.0;
      }
      widget.slideUpdateStream.add(
          new SlideUpdate(
              slidePercent,
              slideDirection,
            UpdateType.dragging,
          ));

      print('Dragging $slideDirection at $slidePercent');
    }
  }

  onDragEnd(DragEndDetails details){
    widget.slideUpdateStream.add(
      new SlideUpdate(0.0, SlideDirection.none, UpdateType.doneDragging)
    );
    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}
class AnimatePageDragger{
  static const PERCENT_PER_MILLISECONO = 0.005;

  final slideDirection;
  final transitionGoal;

  AnimationController completionAnimationController;

  AnimatePageDragger({
      this.slideDirection,
      this.transitionGoal,
      slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }){
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

    if(transitionGoal == TransitionGoal.open){
      endSlidePercent =1.0;
      final slideRemaining = 1.0 -slidePercent;


      duration = new Duration(
        milliseconds : (slideRemaining / PERCENT_PER_MILLISECONO).round()
      );

    }else{
      endSlidePercent = 0.0;
      duration = new Duration(
          milliseconds: (slidePercent/ PERCENT_PER_MILLISECONO).round()
      );
    }

    completionAnimationController = new AnimationController(
      duration:  duration,
      vsync: vsync
    )

    ..addListener(() {

      final slidePercent = lerpDouble(
          startSlidePercent,
          endSlidePercent,
          completionAnimationController.value
      );

      slideUpdateStream.add(
        new SlideUpdate(
          slidePercent,
          slideDirection,
          UpdateType.animating,
        )
      );
    })

    ..addStatusListener((AnimationStatus status){
        if(status == AnimationStatus.completed){
          slideUpdateStream.add(
              new SlideUpdate(
              endSlidePercent,
              slideDirection,
              UpdateType.doneAnimating
              )
          );
        }
    });
  }

  run(){
    completionAnimationController.forward(from: 0.0);
  }

  dispose(){
    completionAnimationController.dispose();
  }

}

enum TransitionGoal{
  open,
  close,
}

enum UpdateType{
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate{
  final updateType;

  final direction;
  final slidePercent;

  SlideUpdate(
      this.slidePercent,
      this.direction,
      this.updateType,
      );
}


