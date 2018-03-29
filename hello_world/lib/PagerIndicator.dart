//import 'dart:ui';

//import 'dart:ui';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hello_world/page.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  PagerIndicator({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {

    List <PageBubble> bubbles = [];
    for(var i = 0; i < viewModel.pages.length; i++){
      final page = viewModel.pages[i];

      var percentActive = viewModel.slidePercent;
      if (i == viewModel.activeIndex){
        percentActive = 1.0- viewModel.slidePercent;
      }else if( i == viewModel.activeIndex - 1 && viewModel.slideDirection == SlideDirection.leftTORight){
        percentActive = viewModel.slidePercent;
      }else if( i == viewModel.activeIndex + 1 && viewModel.slideDirection == SlideDirection.rightToLeft){
        percentActive = viewModel.slidePercent;
    }else{
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex || (i == viewModel.activeIndex && viewModel.slideDirection == SlideDirection.leftTORight);

      bubbles.add(
          new PageBubble(
            viewModel: new PageBubbleViewModel(
                page.iconAssetIcon,
                page.color,
                isHollow,
                percentActive,
            ),
          ),
      );
    };

    final BUBBLE_WIDTH = 55.0;
  final baseTranslation = ((viewModel.pages.length * BUBBLE_WIDTH)/2) - (BUBBLE_WIDTH /2);
  var translation = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDTH);

  if (viewModel.slideDirection == SlideDirection.leftTORight){
    translation += BUBBLE_WIDTH * viewModel.slidePercent;
  }else if (viewModel.slideDirection == SlideDirection.rightToLeft){
    translation -= BUBBLE_WIDTH * viewModel.slidePercent;
  }

    return new Column(
      children: [
        new Expanded(child: new Container()),
        new Transform(
          transform: new Matrix4.translationValues(translation, 0.0, 0.0),

            child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
//          children: [
//            new Padding(
//              padding: const EdgeInsets.all(18.0),
//              child: new Container(
//                width: 15.0,
//                height: 15.0,
//
//                //描述按钮的形状
//                decoration: new BoxDecoration(
//                  shape: BoxShape.circle,
//                  color: const Color(0x88FFFFFF),
//                ),
//              ),
//            ),


//            new PageBubble(
//                viewModel:
//                new PageBubbleViewModel(
//                    'assets/images/bank.png',
//                    Colors.green,
//                    false,
//                    0.0)),
//
//
//            new PageBubble(
//                viewModel:
//                new PageBubbleViewModel(
//                    'assets/images/bank.png',
//                    Colors.green,
//                    false,
//                    1.0)),
//
//            new PageBubble(
//                viewModel:
//                new PageBubbleViewModel(
//                  'assets/images/bank.png',
//                  Colors.green,
//                  false,
//                  0.0)),

//            new Padding(
//              padding: const EdgeInsets.all(18.0),
//              child: new Container(
//                width: 20.0,
//                height: 20.0,
//                decoration: new BoxDecoration(
//                    shape: BoxShape.circle,
//                    border:new Border.all(
//                      color: const Color(0x88FFFFFF),
//                      width:3.0,
//                    )
//                ),
//              ),
//            ),
//          ],
          ),
        ),
      ],
    );
  }
}
enum SlideDirection{
  leftTORight,
  rightToLeft,
  none,
}

class PagerIndicatorViewModel{
  final List<PageViewModel> pages;
  final int activeIndex;
  final double slidePercent;
  final SlideDirection slideDirection;

  PagerIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slidePercent,
      this.slideDirection
  );

}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubble({
    this.viewModel,
});

  @override
  Widget build(BuildContext context) {

    return new Container(
      width: 55.0,
      height: 65.0,

      child: new Center(
        child: new Container(
          width: lerpDouble(20.0,45.0, viewModel.activePercent),
          height: lerpDouble(20.0,45.0, viewModel.activePercent),

          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow
                ? const Color(0x8BFFFFF).withAlpha((0x8B * viewModel.activePercent).round())
                : const Color(0x8BFFFFFF),
            border:new Border.all(
              color: viewModel.isHollow
                    ? const Color(0x8BFFFFF).withAlpha((0x8B *(1- viewModel.activePercent)).round())
                    : Colors.transparent,
              width:3.0,
            ),
          ),
          child: new Opacity(
              opacity: viewModel.activePercent,
              child: new Text('t')
//           child: new Image.asset(
//               viewModel.iconAssetPath,
//               color:viewModel.color),
          ),
        ),
      ),
    );
  }
}

class PageBubbleViewModel{

  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
    this.iconAssetPath,
    this.color,
    this.isHollow,
    this.activePercent,
  );
}



