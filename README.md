[![pub package](https://img.shields.io/pub/v/june.svg)](https://pub.dartlang.org/packages/june)
[![GitHub Stars](https://img.shields.io/github/stars/melodysdreamj/june.svg?style=social&label=Star)](https://github.com/melodysdreamj/june)
[![Documentation](https://img.shields.io/badge/docs-junelee.fun-blue?style=flat-square)](https://junelee.fun/)

# June

> **Full documentation:** [junelee.fun](https://junelee.fun/)

[![Discord](https://img.shields.io/badge/DISCORD-JOIN%20SERVER-5663F7?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/zXXHvAXCug)
[![KakaoTalk](https://img.shields.io/badge/KakaoTalk-Join%20Room-FEE500?style=for-the-badge&logo=kakao)](https://open.kakao.com/o/gEwrffbg)

**June** is a lightweight Flutter state management library that stays true to Flutter's native state management pattern — `setState`, variables, and widgets — without forcing you into a new app architecture.

---

## Why June?

Most state management libraries solve the right problem but go too far. They introduce new patterns, abstractions, and conventions that take over your entire app. June solves only the problem: sharing and updating state across widgets, with minimal ceremony.

| Feature | June |
|---|---|
| No wrapping `MaterialApp` | ✅ |
| No manual initialization | ✅ |
| Works with `StatelessWidget` | ✅ |
| Call `setState` from anywhere | ✅ |
| Multiple instances with tags | ✅ |
| Per-widget local state | ✅ |

---

## Installation

Add June to your `pubspec.yaml`:

```yaml
dependencies:
  june: ^1.0.1
```

Then run:

```sh
flutter pub get
```

---

## Quick Start

### 1. Declare your state

```dart
class CounterVM extends JuneState {
  int count = 0;
}
```

### 2. Wrap your widget with `JuneBuilder`

```dart
JuneBuilder(
  () => CounterVM(),
  builder: (vm) => Text('${vm.count}'),
)
```

### 3. Update state from anywhere

```dart
var vm = June.getState(() => CounterVM());
vm.count++;
vm.setState();
```

That's it. No providers, no streams, no boilerplate.

---

## Full Example

```dart
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
            builder: (vm) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You have pushed the button this many times:'),
                Text(
                  '${vm.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => June.getState(() => CounterVM())
            ..count++
            ..setState(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class CounterVM extends JuneState {
  int count = 0;
}
```

---

## Actions Inside the State

You can define methods directly on your state class to keep logic close to data:

```dart
class CounterVM extends JuneState {
  int count = 0;

  void increment() {
    count++;
    setState();
  }
}
```

Call it from anywhere:

```dart
June.getState(() => CounterVM()).increment();
```

---

## Advanced

### Multiple Instances with Tags

Use `tag` to maintain separate instances of the same state type — useful for list items, feeds, or any repeating structure.

```dart
// Default instance
JuneBuilder(
  () => CounterVM(),
  builder: (vm) => Text('Default: ${vm.count}'),
)

// Tagged instance
JuneBuilder(
  () => CounterVM(),
  tag: 'cardA',
  builder: (vm) => Text('Card A: ${vm.count}'),
)
```

Update a specific tagged instance from anywhere:

```dart
June.getState(() => CounterVM(), tag: 'cardA')
  ..count++
  ..setState();
```

### Per-Widget Local State (`global: false`)

For state tied to a single widget instance — not shared globally — use `global: false`. This is the correct pattern when a state object is created outside June and passed into a widget.

```dart
class MyState extends JuneState {
  int value = 0;

  void increment() {
    value++;
    setState();
  }
}
```

```dart
final myState = MyState();

JuneBuilder(
  () => myState,
  global: false,
  builder: (state) => Text('${state.value}'),
)
```

With `global: false`, June uses the provided instance directly without touching the global registry, so each widget holds its own isolated state. This avoids listener mismatches when the same state type is used across multiple screens or navigation pushes.

> **Note:** Do not pass the instance itself as the `id` parameter. Use `global: false` with plain `setState()` instead. See the [id vs tag](#id-vs-tag) section below.

### Theme Mode Toggle

`JuneBuilder` can wrap `MaterialApp` to rebuild the entire app when state changes:

```dart
class MyController extends JuneState {
  bool isDark = false;

  void toggleTheme() {
    isDark = !isDark;
    setState();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JuneBuilder(
      () => MyController(),
      builder: (c) => MaterialApp(
        theme: ThemeData(),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: c.isDark ? ThemeMode.dark : ThemeMode.light,
        home: const HomeUi(),
      ),
    );
  }
}
```

### Async State / HTTP

June works naturally with async operations. Call `setState()` once data is ready:

```dart
class ApiController extends JuneState {
  String? result;

  Future<void> fetchData() async {
    final res = await http.get(Uri.parse('https://api.example.com/data'));
    result = res.body;
    setState();
  }
}
```

```dart
JuneBuilder(
  () => ApiController(),
  builder: (c) => c.result == null
      ? const CircularProgressIndicator()
      : Text(c.result!),
)
```

---

## Key Concepts

| Concept | Description |
|---|---|
| `JuneState` | Base class for all state objects. Call `setState()` to trigger rebuilds. |
| `JuneBuilder` | Widget that subscribes to a state and rebuilds when `setState()` is called. |
| `June.getState()` | Retrieves the global singleton for a state type, creating it if needed. |
| `tag` | Differentiates multiple registered instances of the same type in the global registry. |
| `global: false` | Bypasses the global registry; the builder uses the provided instance directly. |

### id vs tag

These two parameters serve different purposes:

| Parameter | Purpose | When to use |
|---|---|---|
| `tag` | Selects which registered instance to use from the global registry | Multiple independent instances of the same state type across the app |
| `id` | Selectively triggers only `JuneBuilder` widgets that share the same `id`, when calling `setState([id])` on a single shared state | Partial rebuilds within a single shared state |

---

## Migration

### 0.8.x → 1.0.0

```dart
// Before
June.getState(CounterVM());

// After
June.getState(() => CounterVM());
```

---

## Community

[![Discord](https://img.shields.io/badge/DISCORD-JOIN%20SERVER-5663F7?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/zXXHvAXCug)
[![KakaoTalk](https://img.shields.io/badge/KakaoTalk-Join%20Room-FEE500?style=for-the-badge&logo=kakao)](https://open.kakao.com/o/gEwrffbg)

---

## Acknowledgements

June is inspired by Flutter's native state management, [Provider](https://pub.dev/packages/provider), [GetX](https://pub.dev/packages/get), [Bloc](https://pub.dev/packages/flutter_bloc), and [Svelte](https://svelte.dev/). We are grateful to all contributors and the communities behind these projects for the insights that shaped June.
