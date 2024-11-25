import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/commons/custom_textformfield.dart';
import 'package:mercadinho/commons/mypicked_image.dart';
import 'package:mercadinho/models/users/users.dart';
import 'package:mercadinho/models/users/users_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _socialMedia = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserModel users = UserModel();

  //para armazenar imagens da câmera
  File? _photo;
  File? _image;
  //para armazenar imagens da galeria para ser utilizar no browser
  Uint8List? webImage = Uint8List(8);

  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 45,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Image.asset(
                    'assets/images/logo_flutter.png',
                    height: 100,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Registre-se",
                          style: TextStyle(
                            fontSize: 22,
                            color: Color.fromARGB(255, 213, 107, 8),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          'aplicativo multi-funcional',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 213, 93, 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
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
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  onSaved: (value) => users.userName = value,
                  controller: _userName,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      label: Text("Nome do usuário"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.3),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5))),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      label: Text("E-mail"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.3),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5))),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  enabled: true,
                  labelText: const Text('Telefone'),
                  controller: _phone,
                  prefixIcon: Icons.phone_enabled,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  enabled: true,
                  labelText: const Text('Data de Nascimento'),
                  controller: _birthday,
                  prefixIcon: Icons.calendar_month,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  enabled: true,
                  labelText: const Text('Rede Social'),
                  controller: _socialMedia,
                  prefixIcon: Icons.calendar_month,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  obscureText: true,
                  controller: _password,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      label: Text("Senha"),
                      suffixIcon: Icon(Icons.remove_red_eye),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.3),
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5))),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Consumer<MyPickedImage>(
                      builder: (context, myPickedImage, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            UsersServices usersServices = UsersServices();

                            users.email = _email.text;
                            users.userName = _userName.text;
                            users.password = _password.text;
                            users.birthday = _birthday.text;
                            users.socialMedia = _socialMedia.text;
                            users.phone = _phone.text;

                            if (await usersServices.signUp(users, kIsWeb ? webImage : _photo, kIsWeb)) {
                              if (context.mounted) Navigator.of(context).pop();
                            } else {
                              if (context.mounted) {
                                var snackBar = const SnackBar(
                                  content: Text('Algum erro aconteceu no registro'),
                                  backgroundColor: Color.fromARGB(255, 161, 71, 66),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(50),
                                  elevation: 20,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(elevation: 1.5, minimumSize: const Size.fromHeight(50), shape: LinearBorder.bottom()),
                          child: const Text(
                            'Registrar',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Ou',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 50,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            "Login com Google",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Já tem uma conta?'),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    //condição para obter imagem do dispositivo móvel
    // if (!kIsWeb) {
    //   XFile? image = await picker.pickImage(source: ImageSource.camera, maxWidth: 100, maxHeight: 100);
    //   if (image != null) {
    //     var imageSelected = File(image.path);
    //     setState(() {
    //       _photo = imageSelected;
    //       debugPrint('imagem da câmera');
    //       debugPrint(_photo.toString());
    //     });
    //   }
    // } else if (kIsWeb) {
    //   XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //   if (image != null) {
    //     var imageSelected = await image.readAsBytes(); //converte a imagem para bytes
    //     setState(() {
    //       webImage = imageSelected;
    //       _photo = File('a');
    //       debugPrint('imagem da galeria');
    //       debugPrint(webImage.toString());
    //     });
    //   } else {
    //     debugPrint('nenhuma imagem foi selecionada');
    //   }
    // } else {
    //   debugPrint('Algo errado aconteceu');
    // }
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
