<div align="center">

<br/>

```
     ██╗██╗   ██╗███╗   ██╗███████╗
     ██║██║   ██║████╗  ██║██╔════╝
     ██║██║   ██║██╔██╗ ██║█████╗
██   ██║██║   ██║██║╚██╗██║██╔══╝
╚█████╔╝╚██████╔╝██║ ╚████║███████╗
 ╚════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝
```

### Flutter state management that feels like Flutter.

<br/>

[![Pub Version](https://img.shields.io/pub/v/june.svg?style=for-the-badge&logo=dart&logoColor=white&color=0175C2)](https://pub.dartlang.org/packages/june)
[![Pub Likes](https://img.shields.io/pub/likes/june?style=for-the-badge&logo=dart&logoColor=white&color=0175C2)](https://pub.dartlang.org/packages/june)
[![Pub Points](https://img.shields.io/pub/points/june?style=for-the-badge&logo=dart&logoColor=white&color=0175C2)](https://pub.dartlang.org/packages/june)
[![GitHub Stars](https://img.shields.io/github/stars/melodysdreamj/june?style=for-the-badge&logo=github&logoColor=white&color=181717)](https://github.com/melodysdreamj/june)

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-5663F7?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/zXXHvAXCug)
[![KakaoTalk](https://img.shields.io/badge/KakaoTalk-Join%20Room-FEE500?style=for-the-badge&logo=kakao&logoColor=black)](https://open.kakao.com/o/gEwrffbg)
[![Docs](https://img.shields.io/badge/Full%20Docs-junelee.fun-FF6B6B?style=for-the-badge&logoColor=white)](https://junelee.fun/)

<br/>

</div>

---

<div align="center">

## The problem with state management today

</div>

You learned Flutter. You learned `setState`. It clicked.  
Then you added a library and suddenly you're learning a **new framework inside your framework** — providers, stores, atoms, streams, reducers.

**June refuses to do that.**

It gives you shared, reactive state that works exactly like Flutter's own state management — just without the widget tree dependency. That's it.

<br/>

---

## At a glance

<table>
<tr>
<td width="50%">

**Before June** — state trapped in a widget

```dart
class _CounterState extends State<Counter> {
  int count = 0;         // 🔒 only this widget
                         //    can touch this

  @override
  Widget build(BuildContext context) {
    return Text('$count');
  }
}
```

</td>
<td width="50%">

**With June** — state lives anywhere, rebuilds anything

```dart
class CounterVM extends JuneState {
  int count = 0;         // ✅ any widget,
                         //    any file,
}                        //    anywhere
```

```dart
JuneBuilder(
  () => CounterVM(),
  builder: (vm) => Text('${vm.count}'),
)
```

</td>
</tr>
</table>

<br/>

---

## Why June wins on simplicity

| | June | Provider | GetX | Bloc |
|---|:---:|:---:|:---:|:---:|
| No `MaterialApp` wrapper needed | ✅ | ❌ | ❌ | ❌ |
| No manual initialization | ✅ | ❌ | ✅ | ❌ |
| Works with `StatelessWidget` | ✅ | ✅ | ✅ | ✅ |
| Call `setState` from anywhere | ✅ | ❌ | ✅ | ❌ |
| Multiple tagged instances | ✅ | ❌ | ✅ | ❌ |
| Per-widget isolated state | ✅ | ❌ | ❌ | ❌ |
| Zero new architecture required | ✅ | ❌ | ❌ | ❌ |

<br/>

---

## Installation

```yaml
dependencies:
  june: ^1.0.2
```

```sh
flutter pub get
```

<br/>

---

## Quick start  — 3 steps, 3 minutes

### Step 1 — Define your state

```dart
class CounterVM extends JuneState {
  int count = 0;
}
```

### Step 2 — Subscribe a widget

```dart
JuneBuilder(
  () => CounterVM(),
  builder: (vm) => Text('${vm.count}'),
)
```

### Step 3 — Update from anywhere

```dart
June.getState(() => CounterVM())
  ..count++
  ..setState();
```

> No providers. No streams. No boilerplate. `setState` works the same way it always has — just across the whole app.

<br/>

---

## Full runnable example

```dart
import 'package:flutter/material.dart';
import 'package:june/june.dart';

void main() => runApp(const MyApp());

// ─── State ─────────────────────────────────────────────────────────────────

class CounterVM extends JuneState {
  int count = 0;

  void increment() {
    count++;
    setState();
  }
}

// ─── UI ────────────────────────────────────────────────────────────────────

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
          onPressed: () => June.getState(() => CounterVM()).increment(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

<br/>

---

## Patterns

### Methods on state

Keep logic next to data. Call it from anywhere.

```dart
class CounterVM extends JuneState {
  int count = 0;

  void increment() {
    count++;
    setState();
  }

  void reset() {
    count = 0;
    setState();
  }
}
```

```dart
// From a button, a gesture, a timer — anywhere
June.getState(() => CounterVM()).increment();
```

---

### Multiple instances with `tag`

One state class, many independent instances — perfect for list items, cards, feeds.

```dart
JuneBuilder(
  () => CounterVM(),
  builder: (vm) => Text('Default: ${vm.count}'),
)

JuneBuilder(
  () => CounterVM(),
  tag: 'card_a',
  builder: (vm) => Text('Card A: ${vm.count}'),
)

JuneBuilder(
  () => CounterVM(),
  tag: 'card_b',
  builder: (vm) => Text('Card B: ${vm.count}'),
)
```

```dart
// Update only card A — other instances are unaffected
June.getState(() => CounterVM(), tag: 'card_a')
  ..count++
  ..setState();
```

---

### Per-widget local state with `global: false`

For state that belongs to exactly one widget — not shared globally. Pass your own instance and June won't register it.

```dart
class SliderState extends JuneState {
  double value = 0.5;
}
```

```dart
final sliderState = SliderState();

JuneBuilder(
  () => sliderState,
  global: false,
  builder: (s) => Slider(
    value: s.value,
    onChanged: (v) {
      s.value = v;
      s.setState();
    },
  ),
)
```

> Each widget holds its own isolated state. Navigating away and back creates a fresh instance — exactly what you want for forms, sliders, and single-use UI.

---

### Theme toggle

`JuneBuilder` can wrap `MaterialApp` itself, rebuilding the entire app on state change.

```dart
class ThemeController extends JuneState {
  bool isDark = false;

  void toggle() {
    isDark = !isDark;
    setState();
  }
}
```

```dart
return JuneBuilder(
  () => ThemeController(),
  builder: (c) => MaterialApp(
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: c.isDark ? ThemeMode.dark : ThemeMode.light,
    home: const HomeScreen(),
  ),
);
```

---

### Async state / HTTP

Call `setState()` when your data arrives. Works with any Future or Stream.

```dart
class UserController extends JuneState {
  User? user;
  bool loading = false;

  Future<void> loadUser(String id) async {
    loading = true;
    setState();

    user = await userRepository.fetch(id);
    loading = false;
    setState();
  }
}
```

```dart
JuneBuilder(
  () => UserController(),
  builder: (c) {
    if (c.loading) return const CircularProgressIndicator();
    if (c.user == null) return const Text('No user loaded');
    return Text('Hello, ${c.user!.name}');
  },
)
```

---

### Selective rebuilds with `id`

Trigger only specific `JuneBuilder` widgets inside a shared state, leaving others untouched.

```dart
class FeedState extends JuneState {
  String header = 'Latest';
  List<Post> posts = [];

  void updateHeader(String value) {
    header = value;
    setState('header');          // only rebuilds builders with id: 'header'
  }

  void refreshPosts(List<Post> fresh) {
    posts = fresh;
    setState('posts');           // only rebuilds builders with id: 'posts'
  }
}
```

```dart
// Rebuilds only when 'header' setState is called
JuneBuilder(
  () => FeedState(),
  id: 'header',
  builder: (s) => Text(s.header),
)

// Rebuilds only when 'posts' setState is called
JuneBuilder(
  () => FeedState(),
  id: 'posts',
  builder: (s) => PostList(posts: s.posts),
)
```

<br/>

---

## Core API

| Symbol | Role |
|---|---|
| `JuneState` | Base class for all state objects. Extend it, add fields and methods, call `setState()` to rebuild. |
| `JuneBuilder` | Widget that subscribes to a `JuneState` and rebuilds when `setState()` fires. |
| `June.getState()` | Retrieves (or lazily creates) a global singleton of a state type. Thread-safe, no setup needed. |
| `tag` | Namespaces multiple global instances of the same type. |
| `id` | Enables partial rebuilds — only `JuneBuilder` widgets sharing the same `id` will rebuild. |
| `global: false` | Bypasses the global registry. The builder uses your provided instance directly. |

### `tag` vs `id` — when to use which

| | `tag` | `id` |
|---|---|---|
| **Lives on** | `JuneBuilder` & `June.getState()` | `JuneBuilder` & `setState()` |
| **Purpose** | Pick which stored instance to use | Pick which builders to rebuild |
| **Use when** | Same state type needed in multiple places independently | One shared state, but only some widgets should react to a given change |

<br/>

---

## Migration

### 0.8.x → 1.0.0

The factory function is now passed as a closure rather than an evaluated instance:

```dart
// Before (0.8.x)
June.getState(CounterVM());

// After (1.0.0+)
June.getState(() => CounterVM());
```

<br/>

---

## Community

Questions, ideas, or just want to say hi?

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-5663F7?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/zXXHvAXCug)
[![KakaoTalk](https://img.shields.io/badge/KakaoTalk-Join%20Room-FEE500?style=for-the-badge&logo=kakao&logoColor=black)](https://open.kakao.com/o/gEwrffbg)
[![Docs](https://img.shields.io/badge/Full%20Docs-junelee.fun-FF6B6B?style=for-the-badge&logoColor=white)](https://junelee.fun/)

<br/>

---

## Acknowledgements

June was shaped by the best ideas in the Flutter ecosystem. Gratitude to the teams and communities behind [Provider](https://pub.dev/packages/provider), [GetX](https://pub.dev/packages/get), [Bloc](https://pub.dev/packages/flutter_bloc), and [Riverpod](https://pub.dev/packages/riverpod), and to [Svelte](https://svelte.dev/) for proving that less really is more.

<div align="center"><br/>

Made with care for the Flutter community.

</div>
