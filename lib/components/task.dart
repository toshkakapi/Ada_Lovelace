import 'package:flutter/material.dart';
import 'package:lol/components/code_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lol/components/solution.dart';

// Функция для сохранения прогресса пользователя в Firestore
Future<void> saveUserProgress(String uid, String taskId, String code, List<String> outputs, int successfulTests) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks').doc(taskId).set({
    'code': code, // Сохраняем код пользователя
    'outputs': outputs, // Сохраняем выводы тестов
    'successfulTests': successfulTests, // Количество успешных тестов
  });
}

// Функция для получения прогресса пользователя из Firestore
Future<DocumentSnapshot<Map<String, dynamic>>> getUserProgress(String uid, String taskId) {
  return FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks').doc(taskId).get();
}

class Task extends StatefulWidget {
  final String category;
  final String id; // Уникальный идентификатор задачи
  final String text;
  final String task;
  final List<Map<String, String>> testResults; // Тесты
  final Solution? solution;
  final bool showSolution;

  Task({
    required this.category,
    required this.id,
    required this.text,
    required this.task,
    required this.testResults,
    this.solution,
    this.showSolution = true,
    Key? key,
  }) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List<String> _outputs = [];
  int _successfulTests = 0;
  String _code = '';
  bool _showResultsContainer = false;
  String? uid;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  // Инициализация пользователя и загрузка его прогресса
  Future<void> _initializeUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        uid = currentUser.uid;
      });
      await _loadUserProgress(uid!); // Загружаем прогресс пользователя
    } else {
      // Обработка случая, когда пользователь не авторизован
      debugPrint('Пользователь не авторизован');
    }
  }

  // Загрузка прогресса пользователя из Firestore
  Future<void> _loadUserProgress(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userProgress = await getUserProgress(uid, widget.id);
      if (userProgress.exists) {
        Map<String, dynamic>? data = userProgress.data();
        if (data != null) {
          setState(() {
            _outputs = List<String>.from(data['outputs']);
            _successfulTests = data['successfulTests'];
            _code = data['code'] ?? '';
            _showResultsContainer = true;
          });
        }
      } else {
        setState(() {
          _outputs = List.generate(widget.testResults.length, (_) => '');
          _successfulTests = 0;
          _code = '';
          _showResultsContainer = false;
        });
      }
    } catch (e) {
      debugPrint('Ошибка при загрузке прогресса: $e');
    }
  }

  Future<void> updateUserPoints(String uid, String taskId, int successfulTests, int totalTests) async {
    // Рассчитываем баллы
    int points = ((100.0 / totalTests) * successfulTests).round();

    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

    userDoc.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        int currentPoints = docSnapshot.get('points') ?? 0; // Если баллы не существуют, принимаем 0

        int newPoints = currentPoints + points;

        userDoc.update({'points': newPoints}).then((_) {
          print("Баллы успешно обновлены");
        }).catchError((error) {
          print("Ошибка при обновлении баллов: $error");
        });
      } else {
        print("Документ пользователя не найден");
      }
    });

// Обновляем или создаем поле points в документе пользователя
    userDoc.update({
      'points': FieldValue.increment(points), // Инкрементируем текущее значение баллов
    });
  }

  // Сохранение прогресса пользователя в Firestore
  Future<void> _saveUserProgress() async {
    if (uid != null) {
      await saveUserProgress(uid!, widget.id, _code, _outputs, _successfulTests); // Сохраняем текущие данные задачи

      updateUserPoints(uid!, widget.id, _successfulTests, widget.testResults.length); // Обновляем баллы

      // Проверяем, если все тесты прошли успешно
      if (_successfulTests == widget.testResults.length) {
        // Обновляем количество успешных задач пользователя
        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

        // Инкрементируем поле _successfulTasks, если задача решена
        userDoc.update({
          '_successfulTasks': FieldValue.increment(1), // Инкрементируем количество успешно решённых задач
        }).then((_) {
          print("Количество успешно решённых задач обновлено");
        }).catchError((error) {
          print("Ошибка при обновлении успешных задач: $error");
        });
      }
    }
  }

  // Метод для обновления кода
  void _updateCode(String code) {
    setState(() {
      _code = code;
    });
    _saveUserProgress(); // Сохраняем прогресс
  }

  // Callback для обработки результата выполнения кода
  void _handleRun(int testIndex, String output) {
    setState(() {
      if (testIndex < _outputs.length) {
        _outputs[testIndex] = output;
        widget.testResults[testIndex]['output'] = output;
      }
      _successfulTests = _evaluateTests();
      _showResultsContainer = true;
    });
    _saveUserProgress(); // Сохранение результатов после обновления
  }

  // Метод для оценки количества успешных тестов
  int _evaluateTests() {
    int successful = 0;
    int checkCount = widget.testResults.length;
    for (int i = 0; i < checkCount; i++) {
      if ((widget.testResults[i]['expected'] ?? '').trim() == (_outputs[i].trim())) {
        successful++;
      }
    }
    return successful;
  }

  // Метод для создания ячеек таблицы с автоматическим регулированием размера
  Widget _buildTableCell(String text) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
      child: AutoSizeText(
        text,
        style: TextStyle(
          color: Colors.black.withOpacity(0.7),
          fontWeight: FontWeight.w600,
        ),
        presetFontSizes: [18, 17, 16, 15, 14],
        maxLines: null, // Позволяем тексту занимать любое количество строк
        minFontSize: 14, // Минимальный размер шрифта
        maxFontSize: 18, // Максимальный размер шрифта
      ),
    );
  }

// Метод для построения таблицы с тестами
  Widget _buildTestTable() {
    return Table(
      border: TableBorder.symmetric(
        inside: BorderSide(
          color: Colors.black.withOpacity(0.6),
          width: 2,
        ),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            _buildTableCell('Input'),
            _buildTableCell('Expected'),
            _buildTableCell('Output'),
          ],
        ),
        ...widget.testResults.asMap().entries.take(2).map((entry) {
          int index = entry.key;
          Map<String, String> test = entry.value;

          return TableRow(
            children: [
              _buildTableCell(test['input'] ?? ''),
              _buildTableCell(test['expected'] ?? ''),
              _buildTableCell(_outputs.length > index ? _outputs[index] : ''),
            ],
          );
        }).toList(),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.9;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Номер задачи
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Описание задачи
          AnimatedContainer(
            width: containerWidth,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color.fromRGBO(175, 238, 238, 1.0),
                width: 4,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromRGBO(120, 206, 198, 1.0),
                  width: 5,
                ),
              ),
              child: Text(
                widget.task,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Таблица с тестами
          AnimatedContainer(
            width: containerWidth,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color.fromRGBO(175, 238, 238, 1.0),
                width: 4,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromRGBO(120, 206, 198, 1.0),
                  width: 5,
                ),
              ),
              child: _buildTestTable(),
            ),
          ),


          // Поле для ввода кода и кнопка запуска
          NumberedTextInputPage(
            userId: uid!,
            taskId: widget.id,
            onRun: (result) {
              int testIndex = int.parse(result['index'] ?? '-1');
              String output = result['output'] ?? '';
              _handleRun(testIndex, output);
            },
            onCodeChanged: _updateCode, // Обновляем код
            testResults: widget.testResults, // Передаем все тесты
            isTaskSolved: _successfulTests == widget.testResults.length, // Передаем состояние задачи
          ),

          // Контейнер с результатами тестов
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            height: _showResultsContainer ? 80 : 0, // Высота контейнера по флагу
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            margin: const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: _showResultsContainer
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(3, 5),
                ),
              ]
                  : [], // Если контейнер скрыт, тени нет
            ),
            child: _showResultsContainer
                ? Row(
              children: [
                ImageIcon(
                  _successfulTests == widget.testResults.length
                      ? AssetImage('assets/icons/check-circle.png')
                      : AssetImage('assets/icons/cross-circle.png'),
                  color: _successfulTests == widget.testResults.length
                      ? Colors.green[600] // Зелёный цвет для всех успешных тестов
                      : _successfulTests == 0
                      ? Colors.red[600] // Красный цвет для нуля успешных тестов
                      : Colors.black.withOpacity(0.3), // Цвет для частично успешных тестов
                  size: 40,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'Успешные тесты: $_successfulTests / ${widget.testResults.length}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
                : SizedBox.shrink(),
          ),
          if (widget.showSolution && widget.solution != null) widget.solution!,
        ],
      ),
    );
  }
}
