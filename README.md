## Tabbed Card

It is a custom card with Tabs for keeps multiple contents

## Getting Started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  tabbed_card: ^0.0.1
```

and import it to use 

```dart
import 'package:tabbed_card/tabbed_card.dart';
```

## Example

```dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabbed_card/tabbed_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabbed Card Example',
      scrollBehavior: ScrollConfiguration.of(context)
          .copyWith(scrollbars: false, dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      }),
      home: const MyHomePage(title: 'Tabbed Card'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: TabbedCard(
          tabs: [
            TabbedCardItem(
              label: "Your First Tab",
              child: const Placeholder(),
            ),
            TabbedCardItem(
              label: "Your Second Tab",
              child: const Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}


```
