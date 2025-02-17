import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/commons/custom_textformfield.dart';
// import 'package:mercadinho/commons/dotted_border.dart';
import 'package:mercadinho/models/category/category_service.dart';
import 'package:mercadinho/models/marketing/marketing.dart';
import 'package:mercadinho/models/marketing/marketing_services.dart';
import 'package:mercadinho/models/product/product.dart';
import 'package:mercadinho/models/product/product_services.dart';
import 'package:image_picker/image_picker.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProductServices productServices = ProductServices();
  Product product = Product();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();

  //para armazenar imagens da câmera
  File? _photo;
  File? _image;
  //para armazenar imagens da galeria para ser utilizar no browser
  Uint8List? webImage = Uint8List(8);

  ImagePicker picker = ImagePicker();
  CategoryService categoryService = CategoryService();
  MarketingServices marketingServices = MarketingServices();

  String categoryId = '';
  String marketingId = '';
  String selectMarketing = '';
  var selectedItemCategory;
  String? selectedValue;

  _onTapped(String id) {
    categoryId = id;
  }

  List<Marketing> listMarketing = [];

  prepareMarketingsData() async {
    MarketingServices marketingServices = MarketingServices();
    final Future<List<Marketing>> data = marketingServices.getListMarketings();
    // List<Quote> listQuote = await data;
    listMarketing = await data;

    // listQuote = await data;
  }

  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  @override
  void initState() {
    super.initState();
    prepareMarketingsData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 16.0;
    final TextEditingController menuController = TextEditingController();
    Marketing? selectedMarketing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Produto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _pickImage(),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    width: 100,
                    height: 100,
                    child: _photo == null || webImage!.isEmpty
                        ? dottedBorder(color: Colors.orange)
                        : ClipOval(
                            child: kIsWeb
                                ? Image.memory(
                                    webImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _photo!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  // controller: _name,
                  borderColor: Colors.black54,
                  enabled: true,
                  labelText: const Text("Nome do produto"),
                  onSaved: (value) {
                    product.name = value;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(borderColor: Colors.black54, enabled: true, labelText: const Text("Marca"), onSaved: (value) => product.brand = value),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  controller: _description,
                  borderColor: Colors.black54,
                  enabled: true,
                  labelText: const Text("Descrição do produto"),
                  onSaved: (value) => product.description = value,
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                  stream: categoryService.getCategories(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<DropdownMenuItem<String>> categoryItems = [];
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        categoryItems.add(
                          DropdownMenuItem<String>(
                            value: snap.id,
                            child: Text(
                              snap.get('title'),
                              style: const TextStyle(color: Color(0xff1c313a)),
                            ),
                          ),
                        );
                      }
                      // categoryItems.sort((a, b) => a.length.compareTo(b.length));
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            borderRadius: BorderRadius.circular(10),
                            // dropdownColor: const Color(0xff1c313a),
                            focusColor: const Color.fromARGB(255, 249, 249, 249),
                            items: categoryItems,
                            onChanged: (value) {
                              product.categoryId = value.toString();
                              _onTapped(value.toString());
                              final snackBar = SnackBar(
                                content: Text(
                                  'Categoria atual é $value',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              setState(
                                () {
                                  selectedItemCategory = value.toString();
                                  categoryId = value.toString();
                                },
                              );
                            },
                            value: selectedItemCategory,
                            isExpanded: false,
                            hint: const Text(
                              "Escolha a categoria do produto",
                              style: TextStyle(color: Color.fromARGB(255, 61, 80, 88)),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("marketing").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Ocorreu algum problema na recuperação dos dados: ${snapshot.error}"),
                          );
                        }
                        List<DropdownMenuItem> marketingItems = [];
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          final selectMarketing = snapshot.data?.docs.reversed.toList();
                          if (selectMarketing != null) {
                            for (var marketing in selectMarketing) {
                              marketingItems.add(
                                DropdownMenuItem(
                                  value: marketing.id,
                                  child: Text(
                                    marketing['title'],
                                  ),
                                ),
                              );
                            }
                          }
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              underline: const SizedBox(),
                              isExpanded: true,
                              hint: const Text(
                                "Selecione o Marketing",
                              ),
                              value: selectedValue,
                              items: marketingItems,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  borderColor: Colors.black54,
                  enabled: true,
                  labelText: const Text("Unidade"),
                  onSaved: (value) => product.unity = value!,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  borderColor: Colors.black54,
                  enabled: true,
                  labelText: const Text("Quantidade"),
                  onSaved: (value) => product.quantity = int.parse(value!),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  controller: _price,
                  borderColor: Colors.black54,
                  enabled: true,
                  labelText: const Text("Preço do produto"),
                  onSaved: (value) => product.price = double.parse(value!),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            bool ok = await productServices.save(product: product, imageFile: kIsWeb ? webImage : _photo, plat: kIsWeb);
                            if (mounted && ok) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Alerta!!!'),
                                    content: const Text('Deseja cadastrar outro produto?'),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            formKey.currentState?.reset();
                                            _photo = null;
                                            webImage = Uint8List(8);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Sim')),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Não'))
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } //Rotina para obter a imagem para upload

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              onTap: () {
                imageFromGallery();
                Navigator.of(context).pop();
              },
              leading: const Icon(Icons.photo_library),
              title: const Text(
                'Galeria',
                style: TextStyle(
                  color: Color.fromARGB(255, 1, 17, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                imageFromCamera();
                Navigator.of(context).pop();
              },
              leading: const Icon(Icons.photo_camera),
              title: const Text(
                'Câmera',
                style: TextStyle(
                  color: Color.fromARGB(255, 1, 17, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //obtendo imagem da galeria
  Future imageFromGallery() async {
    //condição para obter imagem do dispositivo móvel
    if (!kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 100, maxHeight: 100);
      if (image != null) {
        var imageSelected = File(image.path);
        setState(() {
          _photo = imageSelected;
        });
      }
    } else if (kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var imageSelected = await image.readAsBytes(); //converte a imagem para bytes
        setState(() {
          webImage = imageSelected;
          _photo = File('a');
        });
      } else {
        debugPrint('nenhuma imagem foi selecionada');
      }
    } else {
      debugPrint('Algo errado aconteceu');
    }
  }

  //obtendo imagem da camera
  Future imageFromCamera() async {
    //condição para obter imagem do dispositivo móvel
    if (!kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.camera, maxWidth: 100, maxHeight: 100);
      if (image != null) {
        var imageSelected = File(image.path);
        setState(() {
          _photo = imageSelected;
        });
      }
    } else if (kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var imageSelected = await image.readAsBytes(); //converte a imagem para bytes
        setState(() {
          webImage = imageSelected;
          _photo = File('a');
        });
      } else {
        debugPrint('nenhuma imagem foi selecionada');
      }
    } else {
      debugPrint('Algo errado aconteceu');
    }
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
              size: 60,
            ),
            Text(
              "Foto",
              style: TextStyle(color: color),
            )
          ],
        ),
      ),
    );
  }
}
