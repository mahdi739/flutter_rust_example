import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rust_example/bridge_generated.dart';

const base = "rust";
final path = Platform.isWindows ? "$base.dll" : "lib$base.so";
late final dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(path);

late final api = RustImpl(dylib);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  String _rustTimerValue = '';
  String _dartTimerValue = '';

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
              child: Text('Start Heavy Work in Rust'),
              onPressed: () async {
                var st = Stopwatch()..start();
                  await api.doHeavyWork();
                st.stop();
                setState(() {
                  _rustTimerValue = st.elapsedMilliseconds.toString() + ' Milliseconds';
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(_rustTimerValue),
            Divider(
              height: 50,
              color: Colors.blue,
            ),
            ElevatedButton(
              child: Text('Start Same Heavy Work in Dart'),
              onPressed: () async {
                var st = Stopwatch()..start();
                //Do Heavy Work Here
                st.stop();
                setState(() {
                  _dartTimerValue = st.elapsedMilliseconds.toString() + ' Milliseconds';
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(_dartTimerValue),
          ],
        ),
      ),
    );
  }
}
