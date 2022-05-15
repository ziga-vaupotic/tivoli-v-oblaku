import 'package:flutter/material.dart';
import 'package:project_tivoli/Menu/Kviz/funQuestions.dart';

class Utils {
  static List<Widget> heightBetween(
    List<Widget> children, {
    @required double height,
  }) {
    if (children.isEmpty) return <Widget>[];
    if (children.length == 1) return children;

    final list = [children.first, SizedBox(height: height)];
    for (int i = 1; i < children.length - 1; i++) {
      final child = children[i];
      list.add(child);
      list.add(SizedBox(height: height));
    }
    list.add(children.last);

    return list;
  }
}

class OptionsWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({
    Key key,
    @required this.question,
    @required this.onClickedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        physics: BouncingScrollPhysics(),
        children: Utils.heightBetween(
          question.options
              .map((option) => buildOption(context, option))
              .toList(),
          height: 8,
        ),
      );

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);

    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            buildAnswer(option),
            buildSolution(question.selectedOption, option),
          ],
        ),
      ),
    );
  }

  Widget buildAnswer(Option option) => Container(
        height: 50,
        child: Row(children: [
          Text(
            option.code,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(width: 12),
          Text(
            option.text,
            style: TextStyle(fontSize: 20),
          )
        ]),
      );

  Widget buildSolution(Option solution, Option answer) {
    if (solution == answer) {
      return Text(
        question.solution,
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      );
    } else {
      return Container();
    }
  }

  Color getColorForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;

    if (!isSelected) {
      return Colors.grey.shade200;
    } else {
      return option.isCorrect ? Colors.green : Colors.red;
    }
  }
}

class QuestionsWidget extends StatelessWidget {
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Option> onClickedOption;
  final List<Question> passed_question;
  final int index;

  const QuestionsWidget({
    Key key,
    @required this.onChangedPage,
    @required this.onClickedOption,
    @required this.passed_question,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final question = passed_question[index];
    return new Scaffold(
      body: buildQuestion(question: question),
    );
  }

  Widget buildQuestion({
    @required Question question,
  }) =>
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              question.text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              'Izberi odgovor',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
            SizedBox(height: 32),
            Expanded(
              child: OptionsWidget(
                question: question,
                onClickedOption: onClickedOption,
              ),
            ),
          ],
        ),
      );
}
