library tabbed_card;

import 'package:flutter/material.dart';

part 'tabbed_card_item.dart';

class TabbedCard extends StatefulWidget {
  const TabbedCard({
    super.key,
    required this.tabs,
    this.contentPadding = const EdgeInsets.all(8),
    this.radius = 15,
    this.elevation = 8,
    this.cardColor,
  }) : assert(tabs.length > 0);

  ///List of tabs
  final List<TabbedCardItem> tabs;

  ///It will be a Radius Circular
  final double radius;

  /// The padding o the content (child)
  final EdgeInsets contentPadding;

  ///The elevation of the card
  final double elevation;

  ///The color of the Card (the tabs can be customizated with the TabbedCardItensOptions) - By default it is the ColorScheme.surface
  final Color? cardColor;

  @override
  State<TabbedCard> createState() => _TabbedCardState();
}

class _TabbedCardState extends State<TabbedCard> {
  List<TabbedCardItem> get tabs => widget.tabs;
  double get radius => widget.radius;
  EdgeInsets get contentPadding => widget.contentPadding;
  double get elevation => widget.elevation;
  Color? get cardColor => widget.cardColor;

  int _currentIndex = 0;

  Radius noRadius = const Radius.circular(0);

  late Radius topLeft;
  late Radius topRight;

  void changeTab(int index, GlobalKey key) {
    _currentIndex = index;
    _selectedTabKey = key;
    _updateBorders();
    setState(() {});
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    topLeft = noRadius;
    topRight = Radius.circular(radius);
    super.initState();
    _scrollController.addListener(() {
      _updateBorders();
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      _updateTabsParams();
    });
  }

  _updateBorders() {
    if (_selectedTabKey != null) {
      _updateTabsParams();
      final Offset selectedOffset = _getGlobalKeyOffset(_selectedTabKey!);
      final Size selectedSize = _getGlobalKeySize(_selectedTabKey!);
      _updateTopLeftRadius(selectedOffset);
      _updateTopRightRadius(selectedOffset, selectedSize);
    }
  }

  _updateTabsParams() {
    if (_tabsKey.currentContext == null) {
      return;
    }
    final RenderBox renderBox = _tabsKey.currentContext?.findRenderObject() as RenderBox;
    tabsOffset = renderBox.localToGlobal(Offset.zero);
    tabsSize = renderBox.size;
  }

  _updateTopLeftRadius(Offset selectedOffset) {
    if (selectedOffset.dx <= tabsOffset.dx) {
      topLeft = noRadius;
    } else if (selectedOffset.dx >= tabsOffset.dx + radius) {
      topLeft = Radius.circular(radius);
    } else {
      topLeft = Radius.circular(selectedOffset.dx - tabsOffset.dx);
    }
  }

  _updateTopRightRadius(Offset selectedOffset, Size selectedSize) {
    final double selectedRightPosition = selectedOffset.dx + selectedSize.width;
    final double tabsRightPosition = tabsOffset.dx + tabsSize.width;
    if (selectedOffset.dx > tabsRightPosition) {
      topRight = Radius.circular(radius);
    } else if (selectedRightPosition >= tabsRightPosition) {
      topRight = noRadius;
    } else if (selectedRightPosition < tabsRightPosition - radius) {
      topRight = Radius.circular(radius);
    } else {
      topRight = Radius.circular(tabsRightPosition - selectedRightPosition);
    }
  }

  final GlobalKey _tabsKey = GlobalKey();
  late Offset tabsOffset;
  late Size tabsSize;
  GlobalKey? _selectedTabKey;

  Offset _getGlobalKeyOffset(GlobalKey key) {
    if (key.currentContext == null) {
      return Offset.zero;
    }
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;

    return renderBox.localToGlobal(Offset.zero);
  }

  Size _getGlobalKeySize(GlobalKey key) {
    if (key.currentContext == null) {
      return Size.zero;
    }
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;

    return renderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: cardColor ?? Theme.of(context).colorScheme.surface.withOpacity(0.7),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 40,
              key: _tabsKey,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: tabs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final bool selected = _currentIndex == index;
                  final TabbedCardItem tab = tabs[index];

                  final GlobalKey tabKey = GlobalKey();

                  if (selected) {
                    _selectedTabKey = tabKey;
                  }

                  return GestureDetector(
                    onTap: () {
                      changeTab(index, tabKey);
                    },
                    child: MouseRegion(
                      cursor: selected ? SystemMouseCursors.basic : SystemMouseCursors.click,
                      child: Container(
                        height: 40,
                        key: tabKey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: tab.options?.tabColor?.withOpacity(selected ? 1 : 0.5) ??
                              (selected ? cardColor ?? Theme.of(context).colorScheme.surface : Colors.transparent),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            topRight: Radius.circular(radius),
                          ),
                        ),
                        child: Builder(builder: (context) {
                          if (tab.icon != null) {
                            return Row(
                              children: [
                                tab.icon!,
                                const SizedBox(width: 5),
                                Text(
                                  tab.label,
                                  style: tab.options?.labelStyle,
                                )
                              ],
                            );
                          }
                          return Center(
                            child: Text(
                              tab.label,
                              style: tab.options?.labelStyle,
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: tabs[_currentIndex].options?.tabColor ?? Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: topLeft,
                    topRight: topRight,
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  )),
              padding: contentPadding,
              child: tabs[_currentIndex].child,
            ),
          ],
        ),
      ),
    );
  }
}
