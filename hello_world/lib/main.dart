// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:flutter/src/painting/image_cache.dart';
import 'package:hello_world/page.dart';


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
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
            new Page(viewModel: new PageViewModel(Colors.blue, 'assets/images/home.png', 'this is body', null, 'flutter')),
        ],
      ),
    );
  }
}


