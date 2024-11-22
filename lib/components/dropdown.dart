import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged;  // Функция для передачи выбранного значения

  Dropdown({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> items = [
    'Абайская область',
    'Акмолинская область',
    'Актюбинская область',
    'Алматинская область',
    'Атырауская область',
    'Восточно-Казахстанская область',
    'Жамбылская область',
    'Жетысуская область',
    'Западно-Казахстанская область',
    'Карагандинская область',
    'Костанайская область',
    'Кызылординская область',
    'Мангыстауская область',
    'Павлодарская область',
    'Северо-Казахстанская область',
    'Туркестанская область',
    'Улытауская область'
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 15), // Внешние отступы контейнера
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(3, 4),
              blurRadius: 3,
              spreadRadius: 1,
            )
          ],
          color: Colors.white, // Фон кнопки
          borderRadius: BorderRadius.circular(10), // Скругление углов
        ),
        child: DropdownButtonHideUnderline( // Убираем стандартную линию под кнопкой
          child: DropdownButton<String>(
            padding: EdgeInsets.symmetric(vertical: 9, horizontal: 25),
            dropdownColor: Colors.white, // Цвет фона выпадающего списка
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black.withOpacity(0.7), // Цвет иконки
            ),
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 17, // Настройки текста для элементов
            ),
            hint: Text(
              "Выберите область",
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            value: selectedValue, // Выбранное значение
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item), // Текст для каждого элемента выпадающего списка
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
              widget.onChanged(newValue); // Передаем выбранное значение наверх
            },
          ),
        ),
    );
  }
}
