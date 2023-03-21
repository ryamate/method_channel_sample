import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(title: 'Calculator'),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, required this.title});

  final String title;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  String _result = '';

  // ① Method Channelを初期化する
  static const platform= MethodChannel('sample.flutter.dev/calculator');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controllerA,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'a'),
              ),
              TextField(
                controller: _controllerB,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'b'),
              ),
              ElevatedButton(
                onPressed: _calculate,
                child: const Text('計算'),
              ),
              Text(_result),
            ],
          ),
        ),
      ),
    );
  }

  // ② Method Channelを呼び出す
  void _calculate() async {
    try {
      final int a = int.parse(_controllerA.text);
      final int b = int.parse(_controllerB.text);
      final int result = await platform.invokeMethod('add', {'a': a, 'b': b});
      setState(() {
        _result = '結果: $result';
      });
    } on PlatformException catch (e) {
      setState(() {
        _result = 'エラーが発生しました: ${e.message}';
      });
    }
  }
}