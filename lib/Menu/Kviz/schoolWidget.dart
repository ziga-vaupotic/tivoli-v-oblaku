import 'package:flutter/material.dart';
import 'package:project_tivoli/Menu/Kviz/schoolQuestions.dart';

typedef void OdgovorCallBack(String val);

class QuestionsWidget extends StatelessWidget {
  final String vprasanje;
  final OdgovorCallBack callback;

  const QuestionsWidget({Key key, this.callback, this.vprasanje})
      : super(key: key);

  Widget build(BuildContext context) {
    final question = vprasanje;
    return new Scaffold(
      body: buildQuestion(question: question, odgovorCallBack: callback),
    );
  }

  static String strOdgovor = "";
  Widget buildQuestion({
    @required String question,
    @required OdgovorCallBack odgovorCallBack,
  }) =>
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 32),
            Text(
              question,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 18),
            TextField(
              onChanged: (String str) => {strOdgovor = str},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Odgovor',
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FlatButton(
                color: Colors.lightBlue,
                onPressed: () {
                    odgovorCallBack(strOdgovor);
                },
                child: Text("Odgovori"),
              )
            )
          ],
        ),
      );
}
