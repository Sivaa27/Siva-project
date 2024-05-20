import 'package:flutter/material.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  Map<String, String?> questionnaireValues = {};
  Map<String, String> remarks = {};
  TextEditingController commentsController = TextEditingController();
  TextEditingController performedByController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionnaire'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildQuestionTile(
            '1. General Appearance, Product Identification, Pump Housing & AC Power Cord',
          ),
          _buildQuestionTile(
            '2. Identification, Product Code & Serial Number in the System must be same with the label on the pump',
          ),
          _buildQuestionTile('3. EST'),
          SizedBox(height: 20),
          TextField(
            controller: commentsController,
            decoration: InputDecoration(
              labelText: 'Comments',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: performedByController,
            decoration: InputDecoration(
              labelText: 'Performed By',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'questionnaireValues': questionnaireValues,
                'remarks': remarks,
                'comments': commentsController.text,
                'performedBy': performedByController.text,
              });
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(question),
          subtitle: Row(
            children: [
              Radio<String>(
                value: 'Pass',
                groupValue: questionnaireValues[question],
                onChanged: (value) {
                  setState(() {
                    questionnaireValues[question] = value;
                  });
                },
              ),
              Text('Pass'),
              Radio<String>(
                value: 'Fail',
                groupValue: questionnaireValues[question],
                onChanged: (value) {
                  setState(() {
                    questionnaireValues[question] = value;
                  });
                },
              ),
              Text('Fail'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Remark',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              remarks[question] = value;
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
