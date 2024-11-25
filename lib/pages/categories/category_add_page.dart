import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/models/category/category.dart';
import 'package:mercadinho/models/category/category_service.dart';

class CategoryAddPage extends StatefulWidget {
  const CategoryAddPage({super.key});

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Category category = Category();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).highlightColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            const Text(
              "Cadastro de Categorias",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black54,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width > 650 ? 650 : MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Título da categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (title) {
                        if (title!.isEmpty) {
                          return 'Campo deve ser preenchido!!!';
                        }
                        return null;
                      },
                      onSaved: (title) => category.title = title,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Descrição do Categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (description) {
                        if (description!.isEmpty) {
                          return 'Campo deve ser preenchido!!!';
                        }
                        return null;
                      },
                      onSaved: (description) => category.description = description,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //código para obtenção da imagem e envio para o Firebase
                    Container(
                      width: MediaQuery.of(context).size.width > 650 ? 500 : MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.width > 650 ? 350 : MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: dottedBorder(color: Colors.blue),
                    ),
                    //Fim do código de upload de imagem
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                CategoryService categoryService = CategoryService();
                                categoryService.add(category);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text("Dados gravados com sucesso!!!")));
                                  _formKey.currentState!.reset();

                                  // Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Problemas ao gravar dados!!!"),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text("Salvar"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//rotina para desenhar o pontilhado na tela
  Widget dottedBorder({required Color color}) {
    return DottedBorder(
      dashPattern: const [6],
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              color: color,
              size: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "Escolha uma Imagem para o produto",
                  style: TextStyle(color: color),
                ))
          ],
        ),
      ),
    );
  }
}
