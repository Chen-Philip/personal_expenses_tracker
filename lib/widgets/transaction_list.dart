import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function deleteTransaction;
  TransactionList(this._userTransactions, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return _userTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  "No transactions added yet",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 15),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: _userTransactions.length,
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 4,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "\$${_userTransactions[index].amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userTransactions[index].title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            DateFormat.yMMMMd()
                                .format(_userTransactions[index].date),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            onPressed: () =>
                                deleteTransaction(_userTransactions[index].id),
                            icon: Icon(Icons.delete),
                            label: Text("Delete"),
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).errorColor,
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                deleteTransaction(_userTransactions[index].id),
                            color: Theme.of(context).errorColor,
                          )
                  ],
                ),
              );
            },
          );
  }
}
