import 'package:flutter/material.dart';

class Question {
  final String text;
  final List<Option> options;
  final String solution;
  bool isLocked;
  Option selectedOption;

  Question({
    @required this.text,
    @required this.options,
    @required this.solution,
    this.isLocked = false,
    this.selectedOption,
  });
}

class Option {
  final String code;
  final String text;
  final bool isCorrect;

  const Option({
    @required this.text,
    @required this.code,
    @required this.isCorrect,
  });
}

final questions = [
  Question(
    text: 'Kolikšna je povprečna višina dreves?',
    options: [
      Option(code: 'A', text: '10m', isCorrect: false),
      Option(code: 'B', text: '15m', isCorrect: true),
      Option(code: 'C', text: '30m', isCorrect: false),
      Option(code: 'D', text: '100m', isCorrect: false),
    ],
    solution: 'Povprečna višina dreves je 15m',
  ),
  Question(
    text: 'Zakaj so drevesa potrebna za življenje?',
    options: [
      Option(code: 'A', text: 'Ker proizvajajo vodo', isCorrect: false),
      Option(code: 'B', text: 'Ker porabljajo kisik', isCorrect: false),
      Option(code: 'C', text: 'Ker pretvarjajo CO₂', isCorrect: true),
      Option(code: 'D', text: 'Ker proizvajajo CO₂', isCorrect: false),
    ],
    solution: 'Drevesa so avtotrofi, ki z uporabo svetlobne energije pri fotosintezi asimilirajo velike količine CO2, kot stranski produkt pa nastaja kisik',
  ),
  Question(
    text: 'Kje se nahaja park tivoli?',
    options: [
      Option(code: 'A', text: 'Ljubljana', isCorrect: true),
      Option(code: 'B', text: 'Maribor', isCorrect: false),
      Option(code: 'C', text: 'Dunaj', isCorrect: false),
      Option(code: 'D', text: 'Jesenice', isCorrect: false),
    ],
    solution: 'Nahaja se v Ljubljani.',
  ),
  Question(
    text:
        'Na kateri strani drevesa raste mah?',
    options: [
      Option(code: 'A', text: 'Severni', isCorrect: true),
      Option(code: 'B', text: 'Južni', isCorrect: false),
      Option(code: 'C', text: "Zahodni", isCorrect: false),
      Option(code: 'D', text: "Vzhodni", isCorrect: false),
    ],
    solution: 'Na severni strani drevesa.',
  ),
  Question(
    text: 'Kdaj je nastal park Tivoli?',
    options: [
      Option(code: 'A', text: '1813', isCorrect: true),
      Option(code: 'B', text: '2001', isCorrect: false),
      Option(code: 'C', text: '1923', isCorrect: false),
      Option(code: 'D', text: '1864', isCorrect: false),
    ],
    solution: 'Park Tivoli so odprli leta 1813.',
  ),
  Question(
    text: 'Kdo je preuredil park Tivoli leta 1939?',
    options: [
      Option(code: 'A', text: 'Jože Plečnik', isCorrect: true),
      Option(code: 'B', text: 'Ne vem', isCorrect: false),
      Option(code: 'C', text: 'Maks Fabiani‎', isCorrect: false),
      Option(
        code: 'D',
        text: 'Edvard Ravnikar‎',
        isCorrect: false,
      ),
    ],
    solution: 'Park Tivoli je preuredil Jože Plečnik.',
  ),
  
  Question(
    text: 'Kako lahko določiš starost drevesa',
    options: [
      Option(code: 'A', text: 'Z velikostjo drevesa', isCorrect: false),
      Option(code: 'B', text: 'S premerom debla', isCorrect: true),
      Option(code: 'C', text: 'S premerom krošnje', isCorrect: false),
      Option(code: 'D', text: 'Z velikostjo vej', isCorrect: false),
    ],
    solution: 'Starost drevesa lahko določimo glede na premer debla s pomočjo rastnega faktroja.',
  ),
];
