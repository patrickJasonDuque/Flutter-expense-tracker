import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//Widgets
import './views/widgets/user_transaction.dart';
import './views/widgets/transaction_input.dart';
import './views/widgets/chart.dart';

//Models
import './views/models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.greenAccent[200]),
        primarySwatch: Colors.indigo,
        accentColor: Colors.greenAccent[200],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Goldman',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.dark().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'Goldman',
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              button: TextStyle(color: Colors.indigo[50])),
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
  List<Transaction> _transactions = [];
  bool _showChart = true;

  List<Transaction> get _recentTransaction {
    return [
      ..._transactions.where((element) =>
          element.date.isAfter(new DateTime.now().subtract(Duration(days: 7))))
    ];
  }

  void _addToTransactionHandler(String title, double amount, DateTime date) {
    setState(() {
      _transactions.add((new Transaction(
          amount: amount,
          title: title,
          id: DateTime.now().toIso8601String(),
          date: date)));
    });
    if (FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: TransactionInput(
              onAddTransaction: _addToTransactionHandler,
            ),
          );
        });
  }

  void _deleteTransactionHandler(String id) {
    setState(() {
      _transactions = [..._transactions.where((tx) => tx.id != id)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar1 = AppBar(
      title: const Text('Expense Tracker'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    return Scaffold(
      appBar: appBar1,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Platform.isIOS
          ? null
          : Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).accentColor,
                onPressed: () => _startAddNewTransaction(context),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Show Chart: '),
                    Switch.adaptive(
                      inactiveThumbColor: Theme.of(context).primaryColor,
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      },
                    ),
                  ],
                ),
              isLandscape
                  ? (_showChart
                      ? Container(
                          height: (mediaQuery.size.height -
                                  appBar1.preferredSize.height -
                                  mediaQuery.padding.top) *
                              .7,
                          child: Chart(_recentTransaction),
                        )
                      : Container(
                          height: (mediaQuery.size.height -
                                  appBar1.preferredSize.height -
                                  mediaQuery.padding.top) *
                              .7,
                          child: UserTransaction(
                              _transactions, _deleteTransactionHandler),
                        ))
                  : Column(children: <Widget>[
                      Container(
                        height: (mediaQuery.size.height -
                                appBar1.preferredSize.height -
                                mediaQuery.padding.top) *
                            .25,
                        child: Chart(_recentTransaction),
                      ),
                      Container(
                        height: (mediaQuery.size.height -
                                appBar1.preferredSize.height -
                                mediaQuery.padding.top) *
                            .7,
                        child: UserTransaction(
                            _transactions, _deleteTransactionHandler),
                      )
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}
