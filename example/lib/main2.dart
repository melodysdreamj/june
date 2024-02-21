import 'package:flutter/material.dart';
import 'package:june/june.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: JuneBuilder(
                () => CounterVM(),
            builder: (vm) =>
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('You have pushed the button this many times:'),
                    Text(
                      '${vm.count}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                  ],
                ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            June.getState(CounterVM()).incrementCounter();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class CounterVM extends JuneState {
  int count = 0;

  incrementCounter() {
    count++;
    setState();
  }
}
