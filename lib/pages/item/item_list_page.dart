import 'package:flutter/material.dart';

class Item {
  final ValueNotifier<String> name;

  Item(String name) : name = ValueNotifier<String>(name);
}

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final List<Item> items = [
    Item('Item 1'),
    Item('Item 2'),
    Item('Item 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final Item item = items[index];

            return Dismissible(
              key: Key(item.name.value),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  items.removeAt(index);
                });
              },
              child: ListTile(
                title: ValueListenableBuilder<String>(
                  valueListenable: item.name,
                  builder: (BuildContext context, String value, child) {
                    return Text(value);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
