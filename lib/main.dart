// main.dart

import 'package:flutter/material.dart';
import 'package:meal_suggester_app/api_services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal Suggester',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _ingredientsController = TextEditingController();
  @override
  void initState() {
    _ingredientsController;
    super.initState();
  }

  @override
  void dispose() {
    _ingredientsController;
    super.dispose();
  }

  String _suggestedMeal = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Suggester'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                  labelText: 'Enter ingredients (comma-separated)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _suggestedMeal = "loading...";
                });
                _suggestMeal();
              },
              child: Text('Get Meal Suggestion'),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 600,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(_suggestedMeal, style: TextStyle(fontSize: 25)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _suggestMeal() async {
    String ingredients = _ingredientsController.text;

    try {
      String suggestedMeal = await ApiService().suggestMeal(ingredients);
      setState(() {
        _suggestedMeal = suggestedMeal;
      });
    } catch (e) {
      // Handle errors
      print('Error: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to get meal suggestion. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
