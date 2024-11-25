import 'package:flutter/material.dart';
import 'package:mercadinho/models/cart/cart_services2.dart';
import 'package:mercadinho/pages/categories/category_add_page.dart';
import 'package:mercadinho/pages/marketing/marketing_add_page.dart';
import 'package:mercadinho/pages/orders/orders_list_page.dart';
import 'package:mercadinho/pages/home/home_page.dart';
import 'package:mercadinho/pages/product/product_add_page.dart';
import 'package:mercadinho/pages/product/product_list_page.dart';
import 'package:mercadinho/pages/userprofile/user_profile_list.dart';
import 'package:mercadinho/pages/userprofile/user_profile_page.dart';
import 'package:mercadinho/models/users/users_services.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ,
        elevation: 2.0,
        actions: [
          Consumer<CartServices2>(
            builder: (context, cartService2, child) {
              return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 24, 0),
                child: GestureDetector(
                  onTap: () {
                    
                  },
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        size: 32,
                      ),
                      if (cartService2.items.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            child: Text(
                              cartService2.items.length.toString(),
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: [
        const HomePage(),
        // const HomePageStream(),

        const OrdersListPage(),
        const UserProfilePage(),
      ][_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int position) {
          setState(() {
            _index = position;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Carrinho',
          ),
          NavigationDestination(
            icon: Icon(Icons.line_style_outlined),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_box_outlined),
            label: 'Perfil de Usuário',
          )
        ],
      ),
      drawer: Consumer<UsersServices>(
        builder: (context, usersServices, child) {
          return Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: ClipOval(
                          child: Image.network(
                            usersServices.userModel!.image!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(usersServices.userModel!.userName!.toUpperCase()),
                      Text(usersServices.userModel!.email!.toLowerCase()),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const ListTile(
                      title: Text('Pedidos'),
                    ),
                    const ListTile(
                      title: Text('Carrinho de Compras'),
                    ),
                    const Divider(
                      height: 2,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfileList(),
                          ),
                        );
                      },
                      title: const Text('Relatório de usuários'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfilePage(),
                          ),
                        );
                      },
                      title: const Text('Perfil de usuário'),
                    ),
                    ExpansionTile(
                        title: const Text("Gerenciamento de Produtos"),
                        leading: const Icon(Icons.person), //add icon
                        childrenPadding: const EdgeInsets.only(left: 60), //children padding
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductAddPage(),
                                ),
                              );
                            },
                            title: const Text('Cadastro de Produtos'),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductListPage(),
                                ),
                              );
                            },
                            title: const Text('Listagem de Produtos'),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CategoryAddPage(),
                                ),
                              );
                            },
                            title: const Text('Categorias de Produtos'),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MarketingAddPage(),
                                ),
                              );
                            },
                            title: const Text('Marketing de Produtos'),
                          ),
                        ]),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
