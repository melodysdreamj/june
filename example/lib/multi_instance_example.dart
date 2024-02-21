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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              JuneBuilder(
                () => CounterVM(),
                builder: (vm) => Column(
                  children: [
                    const Text('Basic instance counter'),
                    Text(
                      '${vm.count}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              JuneBuilder(
                () => CounterVM(),
                tag: "SomeId",
                builder: (vm) => Column(
                  children: [
                    const Text('Object instance counter created with tags'),
                    Text(
                      '${vm.count}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const Stack(
          children: <Widget>[
            Positioned(
                right: 0,
                bottom: 80,
                child: FloatingActionButton.extended(
                    onPressed: increaseBasicInstance, label: Text("Increase basic instance"))),
            Positioned(
                right: 0,
                bottom: 10,
                child: FloatingActionButton.extended(
                    onPressed: increaseObjectInstanceCreatedWithTags, label: Text("Increase object instance created with tags"))),
          ],
        ),
      ),
    );
  }
}

void increaseBasicInstance() {
  var state = June.getState(CounterVM());
  state.count++;
  state.setState();
}

void increaseObjectInstanceCreatedWithTags() {
  var state = June.getState(CounterVM(), tag: "SomeId");
  state.count++;
  state.setState();
}

class CounterVM extends JuneState {
  int count = 0;
}
