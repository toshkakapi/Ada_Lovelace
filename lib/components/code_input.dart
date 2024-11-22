import 'package:flutter/material.dart';
import 'jdoodle_service.dart'; // Импорт JDoodleService
import 'package:cloud_firestore/cloud_firestore.dart';

class NumberedTextInputPage extends StatefulWidget {
  final String userId; // ID пользователя
  final List<Map<String, String>> testResults;
  final Function(Map<String, String> test) onRun;
  final String taskId; // Новый параметр для передачи ID задачи
  final Function(String code) onCodeChanged;
  final bool isTaskSolved;

  const NumberedTextInputPage({
    required this.userId,
    required this.testResults,
    required this.onRun,
    required this.onCodeChanged,
    required this.taskId, // ID задачи
    this.isTaskSolved = false,
    Key? key,
  }) : super(key: key);

  @override
  _NumberedTextInputPageState createState() => _NumberedTextInputPageState();
}

class _NumberedTextInputPageState extends State<NumberedTextInputPage> {
  final TextEditingController _controller = TextEditingController();
  int _lineCount = 5; // Установим начальное количество строк
  final JDoodleService _jdoodleService = JDoodleService(); // Экземпляр сервиса JDoodle
  bool _isLoading = false; // Флаг состояния загрузки
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCodeFromFirestore(); // Загружаем код из Firestore
    _controller.addListener(_updateLineCount); // Добавляем слушатель
  }

  // Загрузка кода из Firestore
  Future<void> _loadCodeFromFirestore() async {
    setState(() {
      _isLoading = true; // Включаем загрузку при извлечении данных
    });

    try {
      DocumentSnapshot taskSnapshot = await _firestore
          .collection('users')
          .doc(widget.userId) // Документ пользователя
          .collection('tasks')
          .doc(widget.taskId) // Документ задачи
          .get();

      if (taskSnapshot.exists) {
        String code = taskSnapshot['code'] ?? ''; // Извлекаем код
        _controller.text = code; // Устанавливаем код в контроллер
      } else {
        print('Task not found.');
      }
    } catch (e) {
      print('Failed to fetch task code: $e');
    } finally {
      setState(() {
        _isLoading = false; // Отключаем загрузку после завершения
      });
    }
  }

  // Уведомляем родителя об изменении кода
  void _notifyCodeChange() {
    widget.onCodeChanged(_controller.text); // Уведомляем о изменениях
  }

  // Обновляем количество строк при изменении текста
  void _updateLineCount() {
    final lines = '\n'.allMatches(_controller.text).length + 1;
    if (lines != _lineCount) {
      setState(() {
        _lineCount = lines > 5 ? lines : 5; // Устанавливаем минимум 5 строк
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateLineCount); // Удаляем слушателя
    _controller.removeListener(_notifyCodeChange);
    _controller.dispose();
    super.dispose();
  }

  // Функция для сохранения кода в Firestore
  Future<void> _saveCodeToFirestore(String code) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'code': code, // Обновляем поле code в документе задачи
      });
    } catch (e) {
      print('Failed to save code to Firestore: $e');
    }
  }

  Future<void> _executeCode() async {
    setState(() {
      _isLoading = true;
    });

    String code = _controller.text;
    String language = 'python3'; // Замените на нужный язык
    String versionIndex = '0'; // Замените на нужную версию

    try {
      for (int index = 0; index < widget.testResults.length; index++) {
        var test = widget.testResults[index];
        String input = test['input'] ?? '';
        String expectedOutput = test['expected'] ?? '';

        Map<String, dynamic> result = await _jdoodleService.executeCode(
          script: code,
          language: language,
          versionIndex: versionIndex,
          stdinInput: {'stdin': input},
        );

        String output = result['output'] ?? '';

        // Сравнение результатов выполнения теста с ожидаемым результатом
        bool isTestSuccessful = output.trim() == expectedOutput.trim();

        // Передаем результат с индексом теста
        widget.onRun({
          'index': index.toString(), // Преобразуем int в String
          'input': input,
          'expected': expectedOutput,
          'output': output,
          'success': isTestSuccessful.toString(),
        });
      }

      // Сохраняем код после успешного выполнения
      await _saveCodeToFirestore(code);

    } catch (e) {
      // Обработка ошибок выполнения
      debugPrint('Ошибка выполнения: $e'); // Логируем ошибку
      widget.onRun({
        'index': '-1', // Указываем, что произошла ошибка, как строка
        'input': '',
        'expected': '',
        'output': 'Ошибка: $e',
        'success': 'false',
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // колонка с номерами строк
              Container(
                width: 40,
                padding: const EdgeInsets.only(top: 9, bottom: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: List.generate(_lineCount, (index) {
                    return Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // разделительная линия
              Container(
                width: 1,
                color: Colors.grey,
              ),

              // контейнер с кодом
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    minLines: 5,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    readOnly: widget.isTaskSolved,
                  ),
                ),
              ),
            ],
          ),

          // kнопка внутри поля ввода
          if (!widget.isTaskSolved)
            Positioned(
              top: 10,
              right: 10,
              child: _isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              )
                  : ElevatedButton(
                onPressed: _executeCode,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  backgroundColor: Colors.green[600], // Зеленая кнопка
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Скругление углов
                  ),
                ),
                child: Text(
                  'Run',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
