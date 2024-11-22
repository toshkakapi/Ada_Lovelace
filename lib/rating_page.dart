import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  bool isLeftButtonSelected = true; // true для Казахстана, false для региона
  String? userRegion;
  bool isLoading = true; // Для контроля состояния загрузки

  @override
  void initState() {
    super.initState();
    _getUserRegion();
  }

  Future<void> _getUserRegion() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userRegion = userDoc['region'];
        });
      }
    }
  }

  void _setLoadingState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(120, 206, 198, 1.0),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Кнопки переключения
              Container(
                margin: const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 10),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
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
                child: Row(
                  children: [
                    // Левая кнопка
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isLeftButtonSelected = true;
                          });
                          _setLoadingState(); // Устанавливаем состояние загрузки с задержкой
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isLeftButtonSelected ? Colors.grey.withOpacity(0.2) : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              "Казахстан",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Разделительная палочка
                    Container(
                      width: 1,
                      height: 38,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    // Правая кнопка
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isLeftButtonSelected = false;
                          });
                          _setLoadingState(); // Устанавливаем состояние загрузки с задержкой
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isLeftButtonSelected ? Colors.grey.withOpacity(0.2) : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              "Область",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // рейтинг
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color.fromRGBO(175, 238, 238, 1.0),
                      width: 4.0,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color.fromRGBO(120, 206, 198, 1.0),
                        width: 6.0,
                      ),
                    ),
                    child: Stack(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where(
                            'region',
                            isEqualTo: isLeftButtonSelected ? null : userRegion,
                          )
                              .orderBy('points', descending: true)
                              .limit(10)
                              .snapshots(),
                          builder: (context, snapshot) {

                            if (snapshot.hasError) {
                              return Center(child: Text('Ошибка: ${snapshot.error}'));
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Center(child: Text('Нет данных'));
                            }

                            final users = snapshot.data!.docs;
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                var user = users[index].data() as Map<String, dynamic>;
                                String username = user['username'];
                                int points = user['points'];
                                var photoUrl = user['photoUrl'] ?? 'assets/images/def_ava3.png';

                                // Список иконок для призовых мест
                                Widget? prizeIcon;
                                if (index == 0) {
                                  prizeIcon = Image.asset('assets/icons/gold-medal.png', height: 50, width: 50);
                                } else if (index == 1) {
                                  prizeIcon = Image.asset('assets/icons/silver-medal.png', height: 50, width: 50);
                                } else if (index == 2) {
                                  prizeIcon = Image.asset('assets/icons/bronze-medal.png', height: 50, width: 50);
                                }

                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.only(left: 5.0, top: 10, right: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
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
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only( right: 15, left: 0),
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      photoUrl,
                                                      width: 55,
                                                      height: 55,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        print('Ошибка загрузки изображения: $error');
                                                        return Image.asset(
                                                          'assets/images/def_ava3.png', // Дефолтное изображение
                                                          width: 55,
                                                          height: 55,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      username,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black.withOpacity(0.7),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Баллы: $points',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black.withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Иконка для призовых мест
                                    if (prizeIcon != null)
                                      Positioned(
                                        right: 30,
                                        top: 20,
                                        child: prizeIcon,
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
