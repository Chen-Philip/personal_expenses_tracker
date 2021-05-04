import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './char_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (tot, item) {
      return tot += item["amount"];
    });
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalAmount = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalAmount += recentTransactions[i].amount;
        }
      }
      return {
        "weekday": DateFormat.E().format(weekday).substring(0, 1),
        "amount": totalAmount,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data["weekday"],
                data["amount"],
                totalSpending == 0.0
                    ? 0.0
                    : (data["amount"] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
