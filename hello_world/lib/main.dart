// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/PagerIndicator.dart';
import 'package:hello_world/page.dart';
import 'package:hello_world/page_dragger.dart';
import 'package:hello_world/page_reveal.dart';


// void main() => runApp(const Center(child: const Text('Hello, world! 1515',textDirection: TextDirection.ltr)));
void main() => runApp(new FlutterView());

// StatelessWidget 为无状态的widget
class FlutterView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new  MaterialApp(
      title: 'Flutter View',  //用于设备识别应用程序的标题
      theme: new ThemeData(   //用于主题调色
        primarySwatch: Colors.grey,
      ),
      home: new MyHomePage(),  //显示主页面的类
    );
  }
}

// StatefulWidget 仅用来表示控件的表现形式，随时可能发生改变
class MyHomePage extends StatefulWidget {

  //声明变量
  @override
  _MyHomePageState createState() =>new  _MyHomePageState();

}

//state内部存储可变状态值，并通过实现build来构建组件
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;

  int activeIndex =0;
  int nextPageIndex = 0;

  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent =0.0;

  _MyHomePageState(){

    slideUpdateStream = new StreamController<SlideUpdate>();

    AnimatePageDragger animatePageDragger;

    slideUpdateStream.stream.listen((SlideUpdate event){

      setState((){
        if (event.updateType == UpdateType.dragging ){
          print('Sliding ${event.direction} at ${event.slidePercent}');
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          nextPageIndex = slideDirection == SlideDirection.leftTORight
              ? activeIndex-1
              : activeIndex +1;

          nextPageIndex.clamp(0.0, pages.length -1);

          if(slideDirection ==SlideDirection.rightToLeft){
            nextPageIndex = activeIndex +1;
          }else if (slideDirection == SlideDirection.leftTORight){
            nextPageIndex = activeIndex - 1;
          }else{
            nextPageIndex = activeIndex;
          }

        }else if(event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatePageDragger = new AnimatePageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatePageDragger = new AnimatePageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

            nextPageIndex = activeIndex;
          }

          animatePageDragger.run();

//          slidePercent = 0.0;
//          slideDirection = SlideDirection.none;
        }else if(event.updateType == UpdateType.animating){
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

        }else if(event.updateType == UpdateType.doneAnimating){
          print('Done animation Next page index: $nextPageIndex');
          activeIndex = nextPageIndex;

          slidePercent = 0.0;
          slideDirection = SlideDirection.none;

          animatePageDragger.dispose();
        }

      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
            new Page(
              viewModel: pages[activeIndex],
              percentVisible: 1.0,
              ),

            new PageReveal(
              revealPercent: slidePercent,
              child: new Page(
                viewModel: pages[nextPageIndex],
                percentVisible: slidePercent,
                ),
            ),

          new PagerIndicator(viewModel:
            new PagerIndicatorViewModel(
                pages,
                activeIndex,
                slidePercent,
                slideDirection,
            ),
          ),

//            new PagerIndicator(viewModel:
//              new PagerIndicatorViewModel(
//                pages,
//                1,
//                0.25,
//                SlideDirection.leftTORight,
//              ),
//            ),


          new PageDragger(
            slideUpdateStream: this.slideUpdateStream,
            canDragLeftToRight:activeIndex >0 ,
            canDragRightToLeft: activeIndex < pages.length - 1,
          ),

        ],
      ),
    );
  }
}

