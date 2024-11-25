import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/commons/responsive.dart';
import 'package:mercadinho/models/product/product_detail_page.dart';
import 'package:mercadinho/models/product/product_services.dart';

class HomePageStream extends StatelessWidget {
  const HomePageStream({super.key});

  @override
  Widget build(BuildContext context) {
    ProductServices productServices = ProductServices();

    return StreamBuilder<QuerySnapshot>(
      stream: productServices.getAllProducts(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Ocorreu um erro ao carregar os produtos.'),
          );
        }

        if (snapshot.hasData) {
          List<DocumentSnapshot> docSnap = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 30.0,
              top: 30,
              left: 20,
              right: 20,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: docSnap.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
                childAspectRatio: .5,
                mainAxisExtent: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.height * .5
                    : MediaQuery.of(context).size.height * .3,
              ),
              itemBuilder: (context, index) {
                final productData = docSnap[index];

                // Verificação de dados antes de usar
                final String name = productData.get('name') ?? 'Produto sem nome';
                final String description = productData.get('description') ?? 'Descrição não disponível';
                final String image = productData.get('image') ?? '';
                final String brand = productData.get('brand') ?? 'Marca não disponível';
                final double price = productData.get('price') != null ? (productData.get('price') as num).toDouble() : 0.0;

                return InkWell(
                  onTap: () {
                    // Verificação adicional ao navegar
                    if (image.isNotEmpty && price > 0.0) {
                      // Navega para a página de detalhes do produto
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            id: productData.id,
                            name: name,
                            description: description,
                            price: price,
                            image: image,
                            brand: brand,
                          ),
                        ),
                      );
                    } else {
                      // Mostra um aviso caso os dados não estejam completos
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informações do produto incompletas'),
                        ),
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Verifica se a imagem está presente e válida
                      Image.network(
                        image.isNotEmpty ? image : 'https://via.placeholder.com/150', // imagem padrão
                        height: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.height * .3
                            : MediaQuery.of(context).size.height * .2,
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.height * .3
                            : MediaQuery.of(context).size.height * .2,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'R\$ ${price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text('Nenhum produto encontrado.'),
          );
        }
      },
    );
  }
}
