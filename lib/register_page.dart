import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/components/textfield.dart';
import 'package:lol/components/sign_button.dart';
import 'package:lol/components/register_button.dart';
import 'package:lol/components/dropdown.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  String? selectedRegion; // Переменная для хранения выбранного региона

  // Метод для регистрации пользователя и добавления данных в Firestore
  void signUserUp() async {
    // Показать индикатор загрузки
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );

    try {
      // Регистрация пользователя
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Получение текущего пользователя
      User? user = userCredential.user;
      if (user != null) {
        // Обновление имени пользователя
        await user.updateProfile(displayName: usernameController.text.trim());
        await user.reload();

        // Добавление пользователя в Firestore с начальными данными
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'points': 0,
          'photoUrl': 'assets/images/def_ava3.png',
          'region': selectedRegion, // Сохраняем выбранный регион
        });
      }
    } on FirebaseAuthException catch (e) {
      // Закрыть индикатор загрузки при ошибке
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }


      return; // Завершаем выполнение метода, чтобы не закрывать диалог дважды
    } finally {
      // Закрытие индикатора загрузки, если он ещё открыт
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }



  void loginUser() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
    await Future.delayed(Duration(milliseconds: 500));

    // Закрыть индикатор загрузки
    Navigator.of(context, rootNavigator: true).pop();
    widget.onTap();
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme
              .of(context)
              .textTheme,
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(120, 206, 198, 1.0),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight - 38,
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 25),
                      const Icon(Icons.lock, color: Colors.white, size: 80),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15,
                            vertical: 0),
                        child: const Text(
                          'Давайте создадим аккаунт для вас!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: usernameController,
                        hintText: 'Имя пользователя',
                        obscureText: false,
                      ),
                      const SizedBox(height: 8),
                      MyTextField(
                        controller: emailController,
                        hintText: 'Электронная почта',
                        obscureText: false,
                      ),
                      const SizedBox(height: 8),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Пароль',
                        obscureText: true,
                      ),
                      const SizedBox(height: 8),
                      Dropdown(
                        onChanged: (value) {
                          setState(() {
                            selectedRegion =
                                value; // Сохраняем выбранный регион
                          });
                        },
                      ),
                      const SizedBox(height: 2),
                      SignButton(
                        onTap: signUserUp,
                        text: 'Зарегистрироваться',
                      ),
                      const Expanded(child: Row()),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Уже есть аккаунт?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            RegisterButton(
                              onTap: loginUser,
                              text: 'Войти',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
