import 'package:flutter/material.dart';
import 'package:lol/components/task.dart';

List<Task> tasks = [
  Task(
    category: '',
    id: 'task_2', // Уникальный идентификатор
    text: 'Задача 2',
    task: 'Напишите программу, которая складывает два числа.',
    testResults: [
      {'input': '5\n3\n', 'expected': '8'},
      {'input': '10\n15\n', 'expected': '25'},
    ],
  ),
  Task(
    category: '',
    id: 'task_3', // Уникальный идентификатор
    text: 'Задача 3',
    task: 'Напишите программу, которая умножает два числа.',
    testResults: [
      {'input': '5\n3\n', 'expected': '15'},
      {'input': '10\n15\n', 'expected': '150'},
    ],
  ),
];