import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol/components/task.dart';
import 'package:lol/components/solution.dart';
import 'package:lol/components/tasks_dropdown.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  String? selectedCategory = 'Все'; // По умолчанию показываем все задачи

  List<Task> allTasks = [
    Task(
      category: 'Строки',
      id: 'task_4', // Уникальный идентификатор
      text: 'Самая длинная подстрока',
      task: 'Дана строка из строчных латинских букв. Найдите длину самой длинной подстроки, состоящей только из одного повторяющегося символа.',
      testResults: [
        {
          'input': 'aabbccccdd',
          'expected': '4',
        },
        {
          'input': 'abcde',
          'expected': '1',
        },
        {
          'input': 'aabbbaaacc',
          'expected': '3',
        },
        {
          'input': 'zzzzzzzz',
          'expected': '8',
        },
        {
          'input': 'ababababab',
          'expected': '1',
        },
      ],
      solution: Solution(code: '''
a = input()
max_count = 1
current_count = 1

for i in range(1, len(a)):
    if a[i] == a[i - 1]:
        current_count += 1
    else:
        max_count = max(max_count, current_count)
        current_count = 1 

print(max(max_count, current_count))'''),
      showSolution: true,
    ),

    Task(
      category: 'Два указателя',
      id: 'task_40', // Уникальный идентификатор
      text: 'Количество подотрезков',
      task: 'Дан массив из n положительных чисел. Необходимо найти количество подмассивов с суммой элементов не меньше k. В первой строке вводятся два числа n и k. Во второй строке n чисел.',
      testResults: [
        {
          'input': '''5 3
1 2 3 4 5''',
          'expected': '13',
        },
        {
          'input': '''5 10
1 2 3 4 5''',
          'expected': '0',
        },
        {
          'input': '''5 3
3 3 3 3 3''',
          'expected': '15',
        },
        {
          'input': '''5 10
1 2 15 4 5''',
          'expected': '8',
        },
        {
          'input': '''6 3
1 1 1 1 1 1''',
          'expected': '10',
        },
      ],
      solution: Solution(code: '''
n, k = map(int, input().split())
a = list(map(int, input().split()))
l = 0
r = 0
s = a[0]
res = 0

while l < len(a):
    if s < k and r < len(a) - 1:
        r += 1
        s += a[r]
    elif s >= k:
        s -= a[l]
        res += n - r
        l += 1
    else:
        l = len(a)
        
print(res)'''),
      showSolution: true,
    ),

    Task(
      category: 'Строки',
      id: 'task_3', // Уникальный идентификатор
      text: 'Строка-палиндром',
      task: 'Напишите функцию, которая проверяет, является ли строка палиндромом (читается одинаково слева направо и справа налево).',
      testResults: [
        {
          'input': 'racecar',
          'expected': 'True',
        },
        {
          'input': 'hello',
          'expected': 'False',
        },
        {
          'input': 'Aba',
          'expected': 'True',
        },
        {
          'input': 'sdkadk',
          'expected': 'False',
        },
        {
          'input': 'A man a plan a canal Panama',
          'expected': 'True',
        },
      ],
      solution: Solution(code: '''s1 = input()
s = list(s1.lower())
flag = True

while ' ' in s:
    s.remove(' ')

for i in range(len(s) // 2):
    if s[i] != s[len(s) - 1 - i]:
        flag = False
        break

print(flag)'''),
      showSolution: true,
    ),


    Task(
      category: 'Математика',
      id: 'task_5', // Уникальный идентификатор
      text: 'Сумма цифр',
      task: 'Дано целое число . Найдите сумму его цифр.',
      testResults: [
        {
          'input': '12345',
          'expected': '15',
        },
        {
          'input': '-345',
          'expected': '12',
        },
        {
          'input': '105',
          'expected': '6',
        },
        {
          'input': '7',
          'expected': '7',
        },
        {
          'input': '987654321',
          'expected': '45',
        },
      ],
      solution: Solution(code: '''
n = int(input())
n = abs(n)
sum = 0
n_str = str(n)

for i in n_str:
    sum += int(i)
    
print(sum)''',),
      showSolution: true,
    ),

    Task(
      category: 'Математика',
      id: 'task_2', // Уникальный идентификатор
      text: 'Факториал числа',
      task: 'Напишите функцию, которая вычисляет факториал числа, введенного пользователем. Факториал n (n!) — это произведение всех целых чисел от 1 до n.',
      testResults: [
        {
          'input': '2',
          'expected': '2',
        },
        {
          'input': '5',
          'expected': '120',
        },
        {
          'input': '6',
          'expected': '720',
        },
        {
          'input': '1',
          'expected': '1',
        },
        {
          'input': '0',
          'expected': '1',
        },
      ],
      solution: Solution(code: '''n = int(input())
factorial = 1

for i in range(1, n + 1):
    factorial *= i

print(factorial)'''),
      showSolution: true,
    ),

    Task(
      category: 'Комбинаторика',
      id: 'task_20', // Уникальный идентификатор
      text: 'Прямоугольники',
      task: 'Найдите количество невырожденных прямоугольников со сторонами, параллельными осям координат, вершины которых лежат в точках с целыми координатами внутри или на границе прямоугольника, противоположные углы которого находятся в точках (0, 0) и (W, Н). Входные данные: два натуральных числа W и H.',
      testResults: [
        {
          'input': '1 1',
          'expected': '1',
        },
        {
          'input': '2 1',
          'expected': '3',
        },
        {
          'input': '2 2',
          'expected': '9',
        },
        {
          'input': '3 2',
          'expected': '18',
        },
      ],
      solution: Solution(code: ''),
      showSolution: true,
    ),

    Task(
      category: 'Теория графов',
      id: 'task_15', // Уникальный идентификатор
      text: 'Дороги',
      task: 'В галактике «Milky Way» на планете «Snowflake» находится N городов, некоторые из которых связаны дорогами. Император галактики хочет провести учет дорог на этой планете. Поскольку он затрудняется с подсчетами, он просит вас написать программу, которая поможет ему определить общее количество дорог, соединяющих города на планете «Snowflake». В первой строке записанно число N, в следующих N строках записано по N чисел, каждое из которых является единичкой или ноликом. Причем, если в позиции (i, j) квадратной матрицы стоит единичка, то i-ый и j-ый города соединены дорогами, а если нолик, то не соединены.',
      testResults: [
        {
          'input': '''3
0 1 0
1 0 1
0 1 0''',
          'expected': '2',
        },
        {
          'input': '''1
0''',
          'expected': '0',
        },
        {
          'input': '''5
0 1 0 0 0
1 0 1 1 0
0 1 0 0 0
0 1 0 0 0
0 0 0 0 0''',
          'expected': '3',
        },
      ],
      solution: Solution(code: ''),
      showSolution: true,
    ),
  ];

  List<Task> get filteredTasks {
    // Если выбрано "Все" или категория не задана, возвращаем все задачи
    if (selectedCategory == null || selectedCategory == 'Все') {
      return allTasks;
    }
    return allTasks.where((task) => task.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(120, 206, 198, 1.0),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 15),
                child: const Text(
                  'Архив задач',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 0),
                child: Dropdown(
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),

              Column(
                children: filteredTasks.map((task) {
                  return Column(
                    children: [
                      Task(
                        category: task.category,
                        id: task.id,
                        text: task.text,
                        task: task.task,
                        testResults: task.testResults,
                        solution: task.solution,
                      )
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


