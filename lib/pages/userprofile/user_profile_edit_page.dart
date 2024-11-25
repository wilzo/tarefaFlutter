import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/commons/mypicked_image.dart';
import 'package:mercadinho/models/users/users.dart';
import 'package:mercadinho/models/users/users_services.dart';
import 'package:provider/provider.dart';

class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({this.users, super.key});
  final UserModel? users;

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  @override
  Widget build(BuildContext context) {
    bool imageUpdate = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Consumer2<UsersServices, MyPickedImage>(
          builder: (context, usersServices, myPickedImage, child) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Editando Perfil de Usuário",
                  style: TextStyle(
                    color: Color.fromARGB(255, 2, 32, 3),
                    fontSize: 28,
                    fontFamily: 'Lustria',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() async {
                      imageUpdate = await Provider.of<MyPickedImage>(context, listen: false).myPickedImage();
                    });
                  },
                  child: imageUpdate & kIsWeb
                      ? Consumer<MyPickedImage>(
                          builder: (context, myPickedImage, child) {
                            if (kIsWeb) {
                              return ClipOval(
                                child: Image.memory(
                                  myPickedImage.webImage!,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              return ClipOval(
                                child: Image.file(
                                  myPickedImage.pickImage!,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                          },
                        )
                      : ClipOval(
                          child: Image.network(
                            usersServices.userModel!.image!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: usersServices.userModel!.userName,
                  decoration: InputDecoration(
                    label: const Text('Nome do Usuário'),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: usersServices.userModel!.phone,
                  decoration: InputDecoration(
                    label: const Text('Telefone'),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: usersServices.userModel!.socialMedia,
                  decoration: InputDecoration(
                    label: const Text('Rede Social'),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: usersServices.userModel!.birthday,
                  decoration: InputDecoration(
                    label: const Text('Data de Nascimento'),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
