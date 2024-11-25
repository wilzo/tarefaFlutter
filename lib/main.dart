import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mercadinho/commons/mypicked_image.dart';
import 'package:mercadinho/models/cart/cart_services.dart';
import 'package:mercadinho/models/cart/cart_services2.dart';
import 'package:mercadinho/pages/authentication/login_page.dart';
import 'package:mercadinho/pages/authentication/signup_page.dart';
import 'package:mercadinho/pages/home/home_page.dart';
import 'package:mercadinho/models/users/users_services.dart'; // Serviço de Usuário
import 'package:mercadinho/pages/main/main_page.dart';
import 'package:mercadinho/user/services/user_model_service.dart'; // Serviço de modelo de usuário
import 'package:provider/provider.dart'; // Provider para gerenciar estado

const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyBg0u1FcDoeJ3Z2CnDgz1lqhhV1IWOV0Mo",
  authDomain: "mercadinho-e1d4b.firebaseapp.com",
  projectId: "mercadinho-e1d4b",
  storageBucket: "mercadinho-e1d4b.firebasestorage.app",
  messagingSenderId: "534028999325",
  appId: "1:534028999325:web:4c33d52bf449b7f89bd274",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializando o Firebase com a configuração
    await Firebase.initializeApp(options: firebaseOptions);
    print('Firebase inicializado com sucesso!');

    runApp(
      MultiProvider(
        providers: [
          // Adicionando os provedores para os serviços de usuário
          ChangeNotifierProvider<UsersServices>(create: (_) => UsersServices()),
          Provider<UserModelService>(create: (_) => UserModelService()),
          ChangeNotifierProvider<MyPickedImage>(create: (_) => MyPickedImage()),

          // Adicionando o Provider para CartServices
         ChangeNotifierProvider<CartServices>(create: (_) => CartServices()),
         ChangeNotifierProvider<CartServices2>(create: (_) => CartServices2()),
          
        ],
        child: MaterialApp(
          title: 'Mercadinho',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // Definindo as rotas nomeadas
          routes: {
            '/login': (context) =>  LoginPage(),
            '/home': (context) => const HomePage(),
            '/signup': (context) => const SignUpPage(),
            '/mainpage': (context) => const MainPage(),  // Rota principal ajustada
          },
          home: Consumer<UsersServices>(builder: (context, usersServices, _) {
            // Condição para verificar se o usuário está autenticado ou não
            return usersServices.userModel == null ?  LoginPage() : const HomePage();
          }),
        ),
      ),
    );
  } catch (e) {
    debugPrint('Erro ao inicializar o Firebase: $e');
  }
}
