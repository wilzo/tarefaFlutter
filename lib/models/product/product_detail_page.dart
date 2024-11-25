import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String brand;

  const ProductDetailPage({
    Key? key,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.brand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name.isNotEmpty ? name : 'Detalhes do Produto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagem do produto
            Image.network(
              image.isNotEmpty ? image : '',
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.grey,
                );
              },
            ),
            const SizedBox(height: 20),

            // Nome do produto
            Text(
              name.isNotEmpty ? name : 'Nome não disponível',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Descrição do produto
            Text(
              description.isNotEmpty
                  ? description
                  : 'Descrição não disponível',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Marca
            Text(
              'Marca: ${brand.isNotEmpty ? brand : 'Não disponível'}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),

            // Preço
            Text(
              'R\$ ${price > 0 ? price.toStringAsFixed(2) : '0.00'}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Spacer(),

            // Botão de voltar
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
