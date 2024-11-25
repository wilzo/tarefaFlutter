import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/models/product/product.dart';
import 'package:mercadinho/models/product/product_services.dart';

class HomePageFuture extends StatelessWidget {
  const HomePageFuture({super.key});

  @override
  Widget build(BuildContext context) {
    ProductServices productServices = ProductServices();
    return Scaffold(
      body: FutureBuilder(
        future: productServices.getDocs(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docSnap = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 30.0,
                top: 30,
                left: 20,
                right: 20,
              ),
              child: Center(
                child: GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.70),
                    itemBuilder: (context, index) {
                      return InkWell(
                        
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Image.network(
                              docSnap[index].get('image'),
                              height: 150,
                              width: 150,
                              scale: 1,
                            ),
                            Text(docSnap[index].get('name')),
                            Text(
                              'R\$ ${docSnap[index].get('price').toString()}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      );
                    }),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
