import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:io';

// Виджет, отвечающий за отображение индикатора загрузки с затемнением области вокруг
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Stack(
      alignment: Alignment.center,
      children: [
        // Полупрозрачный круг вокруг индикатора
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5), // затемненный фон
            shape: BoxShape.circle,
          ),
        ),
        // Индикатор загрузки
        const CircularProgressIndicator(),
      ],
    )
        : Container(); // если не загружается, просто возвращаем пустой контейнер
  }
}

class ProfilePage extends StatefulWidget {
  final ValueNotifier<bool> isLoadingNotifier;

  const ProfilePage({super.key, required this.isLoadingNotifier});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? photoUrl = 'assets/images/def_ava3.png';
  int userPoints = 0;
  int userSucTasks = 0;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserPoints(); // Загрузка очков пользователя
  }

  // Загрузка профиля пользователя (имя и фото)
  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      username = user?.displayName;
      // Если у пользователя есть фото, загружаем его, иначе оставляем дефолтное
      photoUrl = user?.photoURL ?? 'assets/images/def_ava3.png';
    });
  }

  // Загрузка очков пользователя из Firestore
  Future<void> _loadUserPoints() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userPoints = userDoc['points'] ?? 0; // Получение очков, если они существуют
        userSucTasks = userDoc['_successfulTasks'] ?? 0;
      });
    }
  }

  // Метод для выбора и загрузки изображения
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _image = File(image.path);
          widget.isLoadingNotifier.value = true; // Включаем индикатор загрузки
        });
        await _uploadImage();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Загрузка изображения на Firebase Storage и сохранение URL в Firestore
  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      // Получение текущего пользователя
      User? user = FirebaseAuth.instance.currentUser;

      // Создание ссылки на Firebase Storage для сохранения изображения
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user!.uid}.jpg');

      // Загрузка файла в Firebase Storage
      await storageRef.putFile(_image!);

      // Получение URL загруженного изображения
      final downloadUrl = await storageRef.getDownloadURL();

      // Обновление данных пользователя в Firestore с URL изображения
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'photoUrl': downloadUrl,  // Сохраняем URL изображения в Firestore
      });

      // Обновление фото профиля пользователя в Firebase Authentication
      await user.updatePhotoURL(downloadUrl);

      // Обновление локального состояния
      setState(() {
        photoUrl = downloadUrl;
        widget.isLoadingNotifier.value = false;
        _image = null;
      });
    } catch (e) {
      print('Error uploading image: $e');
      widget.isLoadingNotifier.value = false;
    }
  }

  // Сброс аватара на значение по умолчанию
  Future<void> _setDefaultAvatar() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Сброс фото профиля пользователя в Firebase Authentication
      await user?.updatePhotoURL('assets/images/def_ava3.png');

      // Обновление данных пользователя в Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'photoUrl': 'assets/images/def_ava3.png',
      });

      setState(() {
        photoUrl = 'assets/images/def_ava3.png';
      });
    } catch (e) {
      print('Error setting default avatar: $e');
    }
  }

  // Выход из аккаунта
  void signUserOut() async {
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

    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context, rootNavigator: true).pop();
    FirebaseAuth.instance.signOut();
  }

  void _changeUsername() {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Text(
              "Изменение имени пользователя",
              style: TextStyle(
                height: 1.2,
              ),
            ),
          ),
          content: SizedBox(
            width: 400, // Задаем ширину AlertDialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: TextField(
                    controller: usernameController,
                    cursorColor: Colors.black.withOpacity(0.7),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.7),
                          width: 3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(175, 238, 238, 1.0),
                          width: 3,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 22.0, horizontal: 20.0),
                      hintText: 'Новое имя пользователя',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Кнопка "Отмена"
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрываем диалог без изменений
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.black.withOpacity(0.7),
                          width: 2.5,
                        ), // Черная обводка
                      ),
                    ),
                  ),
                  child: Text(
                    'Отмена',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 17
                    ),
                  ),
                ),

                SizedBox(width: 10), // Отступ между кнопками

                // Кнопка "Изменить"
                TextButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    backgroundColor:
                    WidgetStateProperty.all(Colors.black.withOpacity(0.7)),
                  ),
                  onPressed: () async {
                    String newUsername = usernameController.text.trim();
                    if (newUsername.isNotEmpty) {
                      // Обновляем имя в Firebase Authentication
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          await user.updateDisplayName(newUsername);
                          // Обновляем имя пользователя в Firestore
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({'username': newUsername});

                          // Обновляем локальное состояние для отображения
                          setState(() {
                            username = newUsername;
                          });

                          Navigator.of(context).pop(); // Закрываем диалог
                        } catch (e) {
                          print('Error updating username: $e');
                        }
                      }
                    }
                  },
                  child: Text(
                    'Изменить',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }



  // Метод для показа диалогового окна выбора действия
  void _showAvatarDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Выберите действие"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Добавить фото из галереи"),
                onTap: () {
                  Navigator.pop(context);  // Закрываем диалог
                  _pickImage();  // Открываем галерею для выбора фото
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text("Сбросить на начальный аватар"),
                onTap: () {
                  Navigator.pop(context);  // Закрываем диалог
                  _setDefaultAvatar();  // Сбрасываем аватар на начальный
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(120, 206, 198, 1.0),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            // Основное содержимое экрана
            Container(
              height: screenHeight,
              child: Column(
                children: [
                  // Аватарка
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 40, bottom: 20),
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromRGBO(175, 238, 238, 1.0),
                                width: 4.0,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromRGBO(120, 206, 198, 1.0),
                                  width: 6.0,
                                ),
                              ),
                              child: ClipOval(
                                child: Image(
                                  image: photoUrl != 'assets/images/def_ava3.png'
                                      ? NetworkImage(photoUrl!)
                                      : AssetImage('assets/images/def_ava3.png')
                                  as ImageProvider,
                                  width: 230.0,
                                  height: 230.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: GestureDetector(
                              onTap: _showAvatarDialog,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(3, 4),
                                      blurRadius: 2,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black.withOpacity(0.7),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Никнейм
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 100,
                            width: 400,
                            padding: const EdgeInsets.only(
                                top: 13, bottom: 13, left: 20, right: 20),
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color.fromRGBO(175, 238, 238, 1.0),
                                width: 4.0,
                              ),
                            ),
                            child: Center(
                              child: AutoSizeText(
                                username ?? 'Загрузка...',
                                style: const TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                minFontSize: 15.0,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: _changeUsername,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(3, 4),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.black.withOpacity(0.7),
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),

                  Row(
                    children: [
                      // Очки
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 9),
                            margin: const EdgeInsets.only(left: 25, right: 5, top: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Color.fromRGBO(175, 238, 238, 1.0),
                                width: 4.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center, // центрирование элементов по горизонтали
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // центрирование по горизонтали
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 1),
                                      child: const Image(
                                        height: 45,
                                        image: AssetImage('assets/icons/scores.png'),
                                      ),
                                    ),
                                    Text(
                                      userPoints.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(), // добавляем Spacer перед текстом
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Очки опыта',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 15,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Решенные задачи
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 9),
                            margin: const EdgeInsets.only(right: 25, left: 5, top: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Color.fromRGBO(175, 238, 238, 1.0),
                                width: 4.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center, // центрирование элементов по горизонтали
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // центрирование по горизонтали
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 7),
                                      child: Image(
                                        height: 40,
                                        image: AssetImage('assets/icons/check-circle.png'),
                                        color: Colors.green[600],
                                      ),
                                    ),
                                    Text(
                                      userSucTasks.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(), // добавляем Spacer перед текстом
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Решенные задачи',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 15,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),





                  // Включаем индикатор загрузки через ValueListenableBuilder
                  ValueListenableBuilder(
                    valueListenable: widget.isLoadingNotifier,
                    builder: (context, isLoading, _) {
                      return LoadingOverlay(isLoading: isLoading as bool); // Приведение типа к bool
                    },
                  )

                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: signUserOut,
          backgroundColor: Colors.white,
          child: Icon(Icons.logout,
              color: Colors.black.withOpacity(0.7), size: 30),
        ),
      ),
    );
  }
}