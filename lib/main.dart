import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      theme: ThemeData(
        primarySwatch: Colors.green,
        secondaryHeaderColor: Colors.white,
        accentColor: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
          ),
        ),
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 18,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontSize: 20,
                  fontFamily: "OpenSans",
                ),
              ),
        ),
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
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, String amount, DateTime date) {
    final newTran = Transaction(
      title: title,
      amount: double.parse(amount),
      date: date,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTran);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((t) => t.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  Widget build(BuildContext context) {
    final mQuery = MediaQuery.of(context);
    final isLandscape = mQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text("Personal Expenses"),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final transactionList = Container(
      height: (mQuery.size.height -
              appBar.preferredSize.height -
              mQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Show Chart"),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      })
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mQuery.size.height -
                        appBar.preferredSize.height -
                        mQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) transactionList,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mQuery.size.height -
                              appBar.preferredSize.height -
                              mQuery.padding.top) *
                          0.65,
                      child: Chart(_recentTransactions),
                    )
                  : transactionList
          ],
        ),
      ),
    );
  }
}
