import 'package:flutter/material.dart';

final pages = [
  new PageViewModel(
    Colors.blue, 
    'assets/images/home.png', 
    'this is home',
    null, 
    'home'),

  new PageViewModel(
      const Color(0xFF678FB4),
      'assets/images/shop.png',
      'this is shop',
      null,
      'shop'
  ),
  new PageViewModel(
    const Color(0xFF65B0B4),
    'assets/images/bank.png',
    'this is bank',
    null,
    'bank'
  ),
//  new PageViewModel(
//    const Color(0xFF9BBFB4),
//    'assets/images/home.png',
//    'this is body 3',
//     null,
//    'flutter'),
];

class Page extends StatelessWidget {

  final PageViewModel viewModel;
  final double percentVisible;

  Page({
    this.viewModel,
    this.percentVisible = 0.4,
});

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.INFINITY,
      color: viewModel.color,
      child: new Opacity(
        opacity: percentVisible,

        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            new Transform(
              transform: new Matrix4.translationValues(0.0, 50.0*(1.0-percentVisible), 0.0),
              
              child:new Padding(
                padding: new EdgeInsets.only(bottom: 25.0),
                child: new Image.asset(viewModel.hereAssetPath,
                    width: 200.0, height: 200.0
                ),
              ),
            ),

            new Transform(
              transform: new Matrix4.translationValues(0.0, 30.0 * (1.0-percentVisible), 0.0),
              
              child:new Padding(
                padding: new EdgeInsets.only(top:10.0, bottom: 10.0),
                child:new Text(viewModel.title,
                  style: new TextStyle(
                    color: Colors.white,
                    fontFamily: 'Raleway',
                    fontSize: 34.0,
                  ),
                ),
              ),
            ),

            new Transform(
              transform: new Matrix4.translationValues(0.0, 30.0 * (1.0- percentVisible), 0.0),

              child:new Padding(
                  padding: new EdgeInsets.only(bottom:25.0),
                  child: new Text(viewModel.body,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        color: Colors.white,
                        fontFamily: 'Raleway',
                        fontSize: 18.0,
                      )
                  )
              ),
            ),

          ],
        ),
      )
    );
  }
}

class PageViewModel{
  final Color color;
  final String title;
  final String hereAssetPath;
  final String body;
  final String iconAssetIcon;

  PageViewModel(
    this.color,
    this.hereAssetPath,
      this.body,
      this.iconAssetIcon,
      this.title
      );

}


