import 'package:flutter/material.dart';
import 'package:mercadinho/commons/carrosseul_view.dart';
import 'package:mercadinho/commons/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercadinho/pages/home/home_page_stream.dart';
import 'package:mercadinho/pages/product/product_add_page.dart'; // Importando a nova página de cadastro de produto

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory; // Variável para armazenar a categoria selecionada
  List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'Doces'},
    {'id': 2, 'name': 'Bebidas'},
    {'id': 3, 'name': 'Snacks'},
    // Adicione mais categorias conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    // Lista com o caminho das imagens
    List<String> images = [
      'assets/images/image1.jpg',
      'assets/images/image2.jpg',
      'assets/images/image3.jpg',
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '------- ',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 2, 33, 3),
                        ),
                      ),
                      Image.asset(
                        'assets/images/candy.jpg',
                        height: 35,
                      ),
                      Text(
                        ' -------',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 2, 33, 3),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'FestaDoce.com',
                    style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 2, 33, 3),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 40,
                bottom: 25,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  label: Text("Procure por um produto"),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width - 60,
                maxHeight: 200,
              ),
              child: CarouselView(
                itemExtent: 400,
                itemSnapping: true,
                padding: const EdgeInsets.all(5),
                children: List.generate(
                  images.length,
                  (index) => Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'PRODUTOS POPULARES',
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 33, 3),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Divider(
                        color: Color.fromARGB(255, 1, 24, 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Filtro por categoria (categoryId)
            

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: HomePageStream(), // Adicionando HomePageStream
            ),
            // Botão para adicionar novo produto
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navega para a página de adicionar produto
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductAddPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: const Color.fromARGB(255, 2, 33, 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Adicionar Novo Produto',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
