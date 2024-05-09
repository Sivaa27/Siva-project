import 'package:flutter/material.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  Map<String, String?> questionnaireValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('1. General Procedure'),
            subtitle: Row(
              children: [
                Radio<String>(
                  value: 'Pass',
                  groupValue: questionnaireValues['General Procedure'],
                  onChanged: (value) {
                    setState(() {
                      questionnaireValues['General Procedure'] = value;
                    });
                  },
                ),
                Text('Pass'),
                Radio<String>(
                  value: 'Fail',
                  groupValue: questionnaireValues['General Procedure'],
                  onChanged: (value) {
                    setState(() {
                      questionnaireValues['General Procedure'] = value;
                    });
                  },
                ),
                Text('Fail'),
              ],
            ),
          ),
          // Add more questions here with similar structure
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, questionnaireValues);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
