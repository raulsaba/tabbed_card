import 'package:flutter/widgets.dart';

class TabbedCardItem {
  final String label;
  final Widget child;
  final Widget? icon;
  final TabbedCardItensOptions? options;

  TabbedCardItem({
    required this.label,
    required this.child,
    this.icon,
    this.options,
  });
}

class TabbedCardItensOptions {
  final Color? tabColor;
  final TextStyle? labelStyle;

  TabbedCardItensOptions({
    this.tabColor,
    this.labelStyle,
  });
}
