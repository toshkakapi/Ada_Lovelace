
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/components/code_input.dart';
import 'package:lol/components/jdoodle_service.dart'; // Импортируем JDoodleService
import 'package:lol/components/solution.dart';
import 'package:lol/components/task.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(120, 206, 198, 1.0),
      ),
      home: Scaffold(
        body: ListView( // Используем ListView для возможности прокрутки
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30, right: 20, top: 40, bottom: 20),
              child: const Text(
                'Занимайся вместе с Адой!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            // ExpandableContainers(), // Уберите или добавьте по необходимости

            Task(
              category: '',
              id: 'task_1', // Уникальный идентификатор
              text: 'Удвоенное число',
              task: 'Написать функцию, которая удваивает число.',
              testResults: [
                {
                  'input': '2',
                  'expected': '4',
                },
                {
                  'input': '3',
                  'expected': '6',
                },
                {
                  'input': '5',
                  'expected': '10',
                },
              ],
              solution: Solution(code: ''),
              showSolution: false,
            ),

            SizedBox(height: 20,),

            Task(
              category: 'Геометрия',
              id: 'task_10', // Уникальный идентификатор
              text: 'Подсчет пересечений кругов',
              task: 'В плоскости дано N кругов с центрами в точках (x;y) и радиусами r. Определите, сколько пар кругов пересекаются хотя бы в одной точке. Первая строка содержит число N. СледующиеN строк содержат по три числа: x; y; r.',
              testResults: [
                {
                  'input': '''3
0 0 5
10 0 5
5 5 2''',
                  'expected': '1',
                },
                {
                  'input': '''2
0 0 10
0 0 5''',
                  'expected': '0',
                },
                {
                  'input': '''4
0 0 3
10 10 2
20 20 2
30 30 2''',
                  'expected': '0',
                },
              ],
              solution: Solution(code: ''),
              showSolution: false,
            ),

            SizedBox(height: 20,),

            Task(
              category: 'Два указателя',
              id: 'task_2', // Уникальный идентификатор
              text: 'Байдарочный поход',
              task: 'Компания из N человек собирается пойти в байдарочный поход, i-ый человек характеризуется своей массой Mi кг. На лодочной базе имеется в наличии неограниченное количество одинаковых байдарок. Каждая байдарка может вмещать одного или двух людей. Байдарки имеют грузоподъемность D кг. Какое наименьшее количество байдарок придется арендовать компании, чтобы всем отправиться в поход? В первой строке вводится пара натуральных чисел N, D. Во второй строке содержится последовательность натуральных чисел M1, M2, ... , MN',
              testResults: [
                {
                  'input': '''4 135
50 74 60 82''',
                  'expected': '2',
                },
                {
                  'input': '''1 1
1''',
                  'expected': '1',
                },
                {
                  'input': '''6 135
50 120 74 60 100 82''',
                  'expected': '4',
                },
                {
                  'input': '''6 200
80 90 60 70 50 110''',
                  'expected': '3',
                },
                {
                  'input': '''4 100
40 50 30 60''',
                  'expected': '2',
                },
              ],
              solution: Solution(code: ''),
              showSolution: false,
            ),


            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Image.asset('assets/images/Ada.jpg'),
            ),
          ],
        ),
      ),
    );
  }
}
