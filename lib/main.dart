import 'dart:ui';

import 'package:black_game/components/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'models/action_item.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleDragAndDrop(),
      debugShowCheckedModeBanner: true,
    ),
  );
}

@immutable
class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop> {
  bool isDragging = false;
  final List<Item> _items = [];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 80,
              color: Colors.green[100],
              child: ListView.separated(
                padding: const EdgeInsets.all(10.0),
                itemCount: menuItems.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 12.0,
                  );
                },
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _buildMenuItem(
                    onStart: () {
                      setState(() {
                        isDragging = true;
                      });
                    },
                    onEnd: () {
                      setState(() {
                        isDragging = false;
                      });
                    },
                    item: item,
                  );
                },
              ),
            ),
            Expanded(
              child: ReorderableExample(),
            ),
            // _buildPeopleRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required Item item,
    required Function() onStart,
    required Function() onEnd,
  }) {
    return Draggable<Item>(
      data: item,
      dragAnchorStrategy: childDragAnchorStrategy,
      feedback: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 10,
                blurRadius: 20,
                offset: Offset(0, 0))
          ],
          border: Border.all(
            color: item.borderColor,
            width: 5.0,
          ),
        ),
        child: Center(
          child: Icon(item.asset, color: Colors.white, size: 30, weight: 100),
        ),
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: item.borderColor,
            width: 5.0,
          ),
        ),
        child: Center(
          child: Icon(item.asset, color: Colors.white, size: 30, weight: 100),
        ),
      ),
      onDragStarted: () {
        onStart();
      },
      onDragEnd: (details) {
        onEnd();
      },
    );
  }

  Widget ReorderableExample() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ReorderableListView(
            proxyDecorator: proxyDecorator,
            footer: DragTarget<Item>(
              builder: (context, candidateItems, rejectedItems) {
                return placeholder();
              },
              key: const Key('first placeholder'),
              onAccept: (data) {
                if (data.name == "Loop") {
                  setState(() {
                    _items.addAll([data, endLoopItem]);
                  });
                } else {
                  setState(() {
                    _items.add(data);
                  });
                }
              },
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
            children: [
              for (int index = 0; index < _items.length; index += 1)
                Container(
                  padding: const EdgeInsets.all(2),
                  color: Colors.transparent,
                  key: UniqueKey(),
                  child: Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.2,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(10),
                            onPressed: (context) {
                              setState(() {
                                _items.removeAt(index);
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: isDragging
                          ? DragTarget<Item>(
                              builder:
                                  (context, candidateItems, rejectedItems) {
                                if (candidateItems.isNotEmpty) {
                                  return Column(
                                    children: [
                                      placeholder(),
                                      RowFullItemWidget(
                                        item: _items[index],
                                      )
                                    ],
                                  );
                                } else {
                                  return RowFullItemWidget(
                                    item: _items[index],
                                  );
                                }
                              },
                              onAccept: (data) {
                                if (data.name == "Loop") {
                                  setState(() {
                                    _items
                                        .insertAll(index, [data, endLoopItem]);
                                  });
                                } else {
                                  setState(() {
                                    _items.insert(index, data);
                                  });
                                }
                              },
                              key: Key('$index + ${DateTime.now()}'),
                            )
                          : RowFullItemWidget(
                              item: _items[index],
                            )),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

@immutable
class ActionItemWidget extends StatefulWidget {
  final Item item;

  ActionItemWidget({super.key, required this.item});

  @override
  State<ActionItemWidget> createState() => _ActionItemWidgetState();
}

class _ActionItemWidgetState extends State<ActionItemWidget> {
  List<String> details = [];
  String dropdownValue = "";
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    details = widget.item.details ?? [widget.item.name];
    dropdownValue = details.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: double.infinity,
        // margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: widget.item.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.item.detailsBorderColor,
            width: 3.0,
          ),
        ),
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.item.asset, color: Colors.white, size: 30),
            const SizedBox(
              width: 10,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              // width: 200,
              child: DropDown(
                // color: Colors.red,
                cornerRadius: 20,
                color: widget.item.borderColor,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                value: dropdownValue,
                borderColor: widget.item.detailsBorderColor,
                items: widget.item.details ?? [widget.item.name],
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value ?? "";
                  });
                },
              ),
            ),
          ],
        ));
  }
}

class RowFullItemWidget extends StatefulWidget {
  final Item item;

  const RowFullItemWidget({super.key, required this.item});

  @override
  State<RowFullItemWidget> createState() => _RowFullItemWidgetState();
}

class _RowFullItemWidgetState extends State<RowFullItemWidget> {
  List<String> details = [];
  String dropdownValue = "";
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    details = widget.item.options.map((e) => e.toString()).toList();
    dropdownValue = details.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        (widget.item.name == "Light" || widget.item.name == "Sound")
            ? const SizedBox(
                width: 20,
              )
            : const SizedBox(),
        Expanded(flex: 2, child: ActionItemWidget(item: widget.item)),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
              // width: double.infinity,
              // margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
              decoration: BoxDecoration(
                color: widget.item.optionsColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.item.optionsBorderColor,
                  width: 3.0,
                ),
              ),
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_left_rounded,
                      color: Colors.white, size: 30),
                  Expanded(
                    // width: 100,
                    child: DropDown(
                      // color: Colors.red,
                      cornerRadius: 20,
                      color: widget.item.name == "Light"
                          ? getColor(dropdownValue)
                          : widget.item.optionsDropDownColor,
                      dropdownColor: widget.item.optionsDropDownColor,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      value: dropdownValue,
                      borderColor: widget.item.optionsBorderColor,
                      items:
                          widget.item.options.map((e) => e.toString()).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value ?? "";
                        });
                      },
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({super.key});

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  bool isDropdownOpen = true;
  String selectedValue = '';

  List<String> dropdownItems = [
    'Item 1',
    'Item 2',
    'Item 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Listener(
          onPointerDown: (e) {
            setState(() {
              // isDropdownOpen = true;
              isDropdownOpen = !isDropdownOpen;
            });
          },
          child: Container(
              height: 50, color: Colors.amber, child: Text('Open Dropdown')),
        ),
        if (isDropdownOpen)
          Container(
            height: 300,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: dropdownItems.map((item) {
                return Listener(
                  child: Container(
                      height: 50, color: Colors.amber, child: Text(item)),
                  onPointerDown: (e) {
                    setState(() {
                      selectedValue = item;
                      isDropdownOpen = false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        Text('Selected Value: $selectedValue'),
      ],
    );
  }
}

Widget placeholder() {
  return Container(
    width: 50,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
      // border: Border.all(
      //   color: widget.item.detailsBorderColor,
      //   width: 3.0,
      // ),
    ),
    height: 50,
    // child: Text(_items[index].name),
  );
}

Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      final double animValue = Curves.easeInOut.transform(animation.value);
      final double elevation = lerpDouble(6, 6, animValue)!;
      return Material(
        elevation: elevation,
        color: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.5),
        child: child,
      );
    },
    child: child,
  );
}
