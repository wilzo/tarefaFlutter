import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/models/cart/cart_services2.dart';

class OrdersListPage extends StatelessWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    CartServices2 cartServices2 = CartServices2();
    return Scaffold(
      body: StreamBuilder(
          stream: cartServices2.loadAllCart(), //use .snapshot() to get data
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // final current = snapshot.data as Map<String, dynamic>;
              // final items = current["items"] as List;
              // List quantities = items.map((e) => e["quantity"]).toList();
              // List product = items.map((e) => e["product"]).toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  // debugPrint('tamanho : ${snapshot.data!.docs.length}');
                  // debugPrint('doc: ${ds['items'][index]['product']['description']}');
                  final items = ds['items'] as List;
                  // debugPrint('tamanho dos items ${items.length}');
                  // final notes = ds['notesArray'] as List;
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Id do Carrinho: ${ds.id}'),
                        Text('Data do Pedido: ${ds['date']}'),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      width: 55,
                                      height: 55,
                                      items[index]['product']['image'],
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(items[index]['product']['brand']),
                                        Text(items[index]['product']['name']),
                                        // Text(items[index]['product']['unity']),
                                        SizedBox(
                                          width: 400,
                                          child: Text(
                                            items[index]['product']['description'],
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                        const Divider(
                          color: Color.fromARGB(255, 1, 26, 2),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
