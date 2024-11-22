import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  Dropdown({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> items = [
    'Все',
    'Строки',
    'Математика',
    'Комбинаторика',
    'Два указателя'
    'Теория графов',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(3, 4),
            blurRadius: 3,
            spreadRadius: 1,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity, // Задаем ширину контейнера
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 25),
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black.withOpacity(0.7),
            ),
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
            hint: Text(
              "Выберите категорию",
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            value: selectedValue,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
              widget.onChanged(newValue);
            },
            menuMaxHeight: 400,
          ),
        ),
      ),
    );
  }
}
