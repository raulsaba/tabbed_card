library tabbed_card;

import 'package:flutter/material.dart';

import 'tabbed_card_item.dart';

class TabbedCard extends StatefulWidget {
  const TabbedCard({
    super.key,
    required this.tabs,
    this.radius = const Radius.circular(15),
  }) : assert(tabs.length > 0);

  final List<TabbedCardItem> tabs;

  final Radius radius;

  @override
  State<TabbedCard> createState() => _TabbedCardState();
}

class _TabbedCardState extends State<TabbedCard> {
  List<TabbedCardItem> get tabs => widget.tabs;
  Radius get radius => widget.radius;

  int currentIndex = 0;

  Radius noRadius = const Radius.circular(0);

  void changeTab(int index) {
    currentIndex = index;
    setState(() {});
  }

  final ScrollController _tabsScrollController = ScrollController();

  Radius _getTopLeftBorder() {
    return radius;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.transparent,
      borderRadius: BorderRadius.all(radius),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(radius),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ListView.builder(
                controller: _tabsScrollController,
                itemCount: tabs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final bool selected = currentIndex == index;
                  final TabbedCardItem tab = tabs[index];

                  return GestureDetector(
                    onTap: () {
                      changeTab(index);
                    },
                    child: MouseRegion(
                      cursor: selected
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: tab.options?.tabColor
                                  ?.withOpacity(selected ? 1 : 0.5) ??
                              (selected
                                  ? Theme.of(context).colorScheme.surface
                                  : Colors.transparent),
                          borderRadius: BorderRadius.only(
                            topLeft: radius,
                            topRight: radius,
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
                  color: tabs[currentIndex].options?.tabColor ??
                      Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: _getTopLeftBorder(),
                    topRight: radius,
                    bottomLeft: radius,
                    bottomRight: radius,
                  )),
              padding: const EdgeInsets.all(8.0),
              child: tabs[currentIndex].child,
            ),
          ],
        ),
      ),
    );
  }
}
