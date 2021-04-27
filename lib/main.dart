import 'package:flutter/material.dart';
import './transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
      id: 't1',
      title: "Test",
      amount: 5.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: "Groceried",
      amount: 4.99,
      date: DateTime.now(),
    ),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter app"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Card(
              child: Text("CHART"),
              elevation: 5,
              color: Colors.blue,
            ),
          ),
          Column(
            children: transactions.map((tr) {
              return Card(
                child: Text(tr.title),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
