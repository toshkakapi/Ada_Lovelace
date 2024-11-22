import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/components/textfield.dart';
import 'package:lol/components/sign_button.dart';
import 'package:lol/components/register_button.dart';
import 'package:lol/login_or_register_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }


  void signUserIn() async {
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
      // Попытка входа пользователя
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Закрыть индикатор загрузки при ошибке
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Отображение сообщений об ошибках
      if (e.code == 'user-not-found') {
        showErrorDialog('Пользователя с такой электронной почтой не существует');
      } else if (e.code == 'wrong-password') {
        showErrorDialog('Неправильный пароль');
      } else {
        showErrorDialog('Произошла ошибка при входе. Попробуйте снова.');
      }
      return; // Завершаем выполнение метода, чтобы не закрывать диалог дважды
    } finally {
      // Закрытие индикатора загрузки, если он ещё открыт
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }


  void registerUser() async {
    // Показать короткий индикатор загрузки
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );

    // Задержка на 1 секунду
    await Future.delayed(Duration(milliseconds: 500));

    // Закрыть индикатор загрузки
    Navigator.of(context, rootNavigator: true).pop();

    // Переход на страницу регистрации
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Color.fromRGBO(120, 206, 198, 1.0),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight - 38,
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 40),
                      Icon(Icons.lock, color: Colors.white, size: 140),
                      SizedBox(height: 25),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Добро пожаловать!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      MyTextField(
                        controller: emailController,
                        hintText: 'Електронная почта',
                        obscureText: false,
                      ),
                      SizedBox(height: 8),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Пароль',
                        obscureText: true,
                      ),
                      SizedBox(height: 25),
                      SignButton(
                        onTap: signUserIn,
                        text: 'Войти',
                      ),
                      Expanded(
                        child: Row(),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Нет учётной записи?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            RegisterButton(
                              onTap: registerUser,
                              text: 'Регистрация',
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
