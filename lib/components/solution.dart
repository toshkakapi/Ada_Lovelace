import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Solution extends StatefulWidget {
  final String code;

  const Solution({required this.code, Key? key}) : super(key: key);

  @override
  _SolutionState createState() => _SolutionState();
}

class _SolutionState extends State<Solution> {
  late TextEditingController _controller;
  late int _lineCount;
  bool _isExtraContainerVisible = false;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.code);
    _lineCount = widget.code.split('\n').length;
    if (_lineCount < 5) {
      _lineCount = 5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExtraContainer() {
    setState(() {
      _isExtraContainerVisible = !_isExtraContainerVisible;
    });
  }

  void _onButtonPressedDown() {
    setState(() {
      _isButtonPressed = true;
    });
  }

  void _onButtonPressedUp() {
    setState(() {
      _isButtonPressed = false;
      _toggleExtraContainer();
    });
  }

  // Calculate the number of lines in the provided code
  void _updateLineCount() {
    final lines = '\n'.allMatches(widget.code).length + 1;
    setState(() {
      _lineCount = lines > 5 ? lines : 5; // Ensure minimum 5 lines
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Кнопка для решения
        GestureDetector(
          onTapDown: (_) => _onButtonPressedDown(),
          onTapUp: (_) => _onButtonPressedUp(),
          onTapCancel: () => _onButtonPressedUp(),
          child: Container(
            height: 60,
            margin: EdgeInsets.only(
              left: _isButtonPressed ? 25 : 20,
              top: _isButtonPressed ? 20 : 15,
              bottom: _isButtonPressed ? 15 : 20,
              right: _isButtonPressed ? 15 : 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: _isButtonPressed
                  ? [
                const BoxShadow(
                  color: Color.fromRGBO(120, 206, 198, 1.0),
                  offset: Offset(3, 5),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(3, 5),
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Center(
              child: AutoSizeText(
                _isExtraContainerVisible ? 'Скрыть решение' : 'Показать решение',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                minFontSize: 12.0,
              ),
            ),
          ),
        ),

          // Контейнер с кодом
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: _isExtraContainerVisible
              ? Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Закругленные углы
              border: Border.all(color: Colors.grey), // Добавляем границу
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Колонка с номерами строк
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
                                fontSize: 16, // Размер шрифта номера строки
                                height: 1.5, // Межстрочный интервал
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Разделительная линия
                    Container(
                      width: 1,
                      color: Colors.grey,
                    ),

                    // Контейнер с кодом
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7), // Фоновый цвет для TextField
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                            readOnly: true,
                            scrollPhysics: BouncingScrollPhysics(),
                          ),
                      ),
                    ),
                    ),
                  ],
                ),
              ],
            ),
          )

              : const SizedBox.shrink(), // Пустой контейнер, если скрыто
    )
      ],
          );
  }
}

