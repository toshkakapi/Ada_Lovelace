import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/home_page.dart';
import 'package:lol/profile_page.dart';
import 'package:lol/ada_page.dart';
import 'package:lol/rating_page.dart';
import 'package:lol/archive_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key}); // Use const constructor for better performance

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomePage(),
      ArchivePage(),
      AdaPage(),
      RatingPage(),
      ProfilePage(
        isLoadingNotifier: _isLoadingNotifier,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: const Color.fromRGBO(120, 206, 198, 1.0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color.fromRGBO(120, 206, 198, 1.0),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              _pages[_selectedIndex],
              ValueListenableBuilder<bool>(
                valueListenable: _isLoadingNotifier,
                builder: (context, isLoading, child) {
                  if (isLoading) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromRGBO(175, 238, 238, 1.0),
                width: 2.0,
              ),
            ),
          ),
          height: 65,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
              items: [
                // Home
                BottomNavigationBarItem(
                  icon: AnimatedContainer(
                    margin: const EdgeInsets.only(top: 10),
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/icons/home.png',
                      height: 26,
                      width: 26,
                      color: Colors.white,
                    ),
                  ),
                  label: '',
                  activeIcon: AnimatedContainer(
                    margin: const EdgeInsets.only(top: 8),
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/icons/home-closed.png',
                      height: 29,
                      width: 29,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Archive
                BottomNavigationBarItem(
                  icon: AnimatedContainer(
                    margin: const EdgeInsets.only(top: 10),
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/icons/tasks.png',
                      height: 27,
                      width: 27,
                      color: Colors.white,
                    ),
                  ),
                  label: '',
                  activeIcon: AnimatedContainer(
                    margin: const EdgeInsets.only(top: 8),
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/icons/tasks-open.png',
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Ada
                BottomNavigationBarItem(
                  icon: AnimatedContainer(
                    margin: _selectedIndex == 2
                        ? const EdgeInsets.only(bottom: 0, top: 2)
                        : const EdgeInsets.only(bottom: 0, top: 4),
                    duration: const Duration(milliseconds: 300),
                    width: _selectedIndex == 2 ? 45 : 40,
                    height: _selectedIndex == 2 ? 45 : 40,
                    child: Image.asset('assets/images/Ada1.png'),
                  ),
                  label: '',
                ),

                // Rating
                BottomNavigationBarItem(
                  icon: AnimatedContainer(
                    margin: const EdgeInsets.only(top: 10),
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/icons/rank.png',
                      height: 26,
                      width: 26,
                      color: Colors.white,
                    ),
                  ),
                  label: '',
                  activeIcon: AnimatedContainer(
                    margin: const EdgeInsets.only(top: 8),
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/icons/rank-open.png',
                      height: 29,
                      width: 29,
                      color: Colors.white,
                    ),
                  ),
                ),

                // User
                BottomNavigationBarItem(
                  icon: AnimatedContainer(
                    margin: const EdgeInsets.only(top: 10),
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/icons/user.png',
                      height: 26,
                      width: 26,
                      color: Colors.white,
                    ),
                  ),
                  label: '',
                  activeIcon: AnimatedContainer(
                    margin: const EdgeInsets.only(top: 8),
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      'assets/icons/user-closed.png',
                      height: 29,
                      width: 29,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  @override
  void dispose() {
    _isLoadingNotifier.dispose();
    super.dispose();
  }
}
