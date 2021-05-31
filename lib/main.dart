import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {//因為使用兩個Controller, 所以改用TickerProviderStateMixin
  int _counter = 0;

  AnimationController _expansionController;
  AnimationController _opacityController;

  @override
  void initState() {
    _expansionController = AnimationController(
      // duration: Duration(seconds: 4),
      vsync: this,
    );
    _opacityController = AnimationController(
      // duration: Duration(seconds: 4),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _expansionController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Animation animation1 = Tween(begin: 0.0, end: 1.0)
    //     .chain(CurveTween(curve: Interval(0.0, 0.2)))
    // 0.2原因, 4/20, 前20秒時間跑完整段動畫效果Tween(begin: 0.0, end: 1.0).
    //     .animate(_controller);

    // Animation animation3 = Tween(begin: 1.0, end: 0.0)
    //     .chain(CurveTween(curve: Interval(0.4, 0.95 )))
    //     .animate(_controller);
    // 4/20 = 0.2, 7/20= 0.35 , 8/20 = 0.4, 0.2+0.35+0.4=0.95

    /// ++++ 0000000 -------- 0
    /// 四秒吸 + 七秒憋氣 + 八秒吐氣 + 1秒休息, 總時長20秒

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.5).animate(_opacityController),//因為0的話會完全看不到值, 所以改成0.5
          child: AnimatedBuilder(
            animation: _expansionController,
            //animation 事實上不在乎_controller的數值是多少, 他只在乎_controller什麼時候有變化
            builder: (BuildContext context, Widget child) {
              return Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue[600],
                      Colors.blue[100],
                    ],
                    stops:[_expansionController.value, _expansionController.value+0.1],
                    // _controller.value<= 0.2 ?
                    // [animation1.value, animation1.value + 0.1]: //從0~0.5填第一種顏色, 過了1.0界線後填入下一個顏色
                    //   [animation3.value, animation3.value + 0.1]
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          _expansionController.duration = Duration(seconds: 4);//設定控制器的時長是4秒
          _expansionController.forward();
          await Future.delayed(Duration(seconds: 4));//異步執行 async + await

          _opacityController.duration = Duration(milliseconds: 1750);
          _opacityController.repeat(reverse: true);
          await Future.delayed(Duration(seconds: 7));
          _opacityController.reset();

          _expansionController.duration = Duration(seconds: 8);
          _expansionController.reverse();//倒放


          // _controller.repeat(reverse: true);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
