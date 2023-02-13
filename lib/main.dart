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

void runDartSync() {
  //Do somthing
}
Future<void> runDartASync() async {
  //Do somthing
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

  String _rustAsyncElapsed = '';
  String _rustSyncElapsed = '';
  String _dartAsyncElapsed = '';
  String _dartSyncElapsed = '';
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
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepOrangeAccent)),
              child: const Text('Run Rust Async'),
              onPressed: () async {
                var st = Stopwatch()..start();
                await api.doHeavyWork();
                st.stop();
                setState(() {
                  _rustAsyncElapsed = st.elapsedMicroseconds.toString() + ' Microseconds';
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(_rustAsyncElapsed),
            const Divider(
              height: 40,
              color: Colors.black87,
              thickness: 1.5,
            ),
            ////////////
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepOrangeAccent)),
              child: const Text('Run Rust Sync'),
              onPressed: () {
                var st = Stopwatch()..start();
                api.doLightWork();
                st.stop();
                setState(() {
                  _rustSyncElapsed = st.elapsedMicroseconds.toString() + ' Microseconds';
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(_rustSyncElapsed),
            const Divider(
              height: 40,
              color: Colors.black87,
              thickness: 1.5,
            ),
            ////////////
            ElevatedButton(
              child: const Text('Run Dart Async'),
              onPressed: () async {
                var st = Stopwatch()..start();
                await runDartASync();
                st.stop();
                setState(() {
                  _dartAsyncElapsed = st.elapsedMicroseconds.toString() + ' Microseconds';
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(_dartAsyncElapsed),
            const Divider(
              height: 40,
              color: Colors.black87,
              thickness: 1.5,
            ),
            ////////////
            ElevatedButton(
              child: const Text('Run Dart Sync'),
              onPressed: () async {
                var st = Stopwatch()..start();
                runDartSync();
                st.stop();
                setState(() {
                  _dartSyncElapsed = st.elapsedMicroseconds.toString() + ' Microseconds';
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(_dartSyncElapsed),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
