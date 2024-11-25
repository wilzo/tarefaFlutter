import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/models/product/product_services.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductServices productServices = ProductServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Listagem de Produtos"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Buscar",
                  hintText: "Filtra por nome do produto",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  )),
              onChanged: (name) {},
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
                stream: productServices.getAllProducts(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot docSnapshot = snapshot.data!.docs[index];
                          return Card(
                            child: Row(children: [
                              Image.network(
                                height: 50,
                                docSnapshot['image'],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    docSnapshot['name'],
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'R\$ ${docSnapshot['price'].toString()}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ]),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                })
          ],
        ),
      ),
    );
  }
}
