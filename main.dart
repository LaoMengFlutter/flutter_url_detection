import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL检测',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'URL检测'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _resultText = '';
  List<String> _urls = [
    'https://www.baidu.com',
    'https://flutter.dev/',
    'https://flutterchina.club/',
    'https://juejin.cn/',
    'https://blog.csdn.net/',
    'https://www.zhihu.com/',
    'https://www.jianshu.com/',
    'https://developer.android.google.cn/reference/classes',
    'https://kotlinlang.org/',
    'https://api.flutter.dev/index.html'
  ];
  int _currentIndex = -1;

  Future<String> _fetchResponseTime(String url) async {
    var stopwatch = Stopwatch()..start();
    var response = await http.get(Uri.parse(url));
    stopwatch.stop();
    return '${response.statusCode} ${response.reasonPhrase} ${stopwatch.elapsedMilliseconds}ms';
  }

  Future<void> _checkResponseTime() async {
    int fastestIndex = -1;
    int fastestTime = -1;

    for (int i = 0; i < _urls.length; i++) {
      var responseTime = await _fetchResponseTime(_urls[i]);
      setState(() {
        _resultText += '\n$responseTime';
      });

      var time = int.parse(responseTime.split(' ').last.replaceAll('ms', ''));
      if (fastestTime == -1 || time < fastestTime) {
        fastestIndex = i;
        fastestTime = time;
      }
    }

    setState(() {
      _currentIndex = fastestIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _currentIndex == -1 ? _checkResponseTime : null,
              child: Text('开始检测'),
            ),
            SizedBox(height: 16.0),
            Text(_currentIndex == -1 ? '' : '最快的 URL 是：${_urls[_currentIndex]}')
          ],
        ),
      ),
      bottomSheet: Container(
        height: 200,
        child: SingleChildScrollView(
          child: Text(_resultText),
        ),
      ),
    );
  }
}
