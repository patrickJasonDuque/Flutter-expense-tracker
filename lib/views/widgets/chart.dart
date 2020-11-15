import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart(this.recentTransactions);

  double get totalSpending {
    return recentTransactions.fold(0, (sum, item) => item.amount + sum);
  }

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double total = 0;

      for (int i = 0; recentTransactions.length > i; i++) {
        if ((recentTransactions[i].date.day == weekday.day) &&
            (recentTransactions[i].date.month == weekday.month) &&
            (recentTransactions[i].date.year == weekday.year))
          total += recentTransactions[i].amount;
      }

      return {'day': DateFormat.E().format(weekday), 'amount': total};
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .22,
      child: Card(
        color: Theme.of(context).accentColor,
        elevation: 6,
        margin: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ...groupedTransactions.map((recentTx) => Expanded(
                    child: ChartBar(
                      label: recentTx['day'],
                      spendingAmount: recentTx['amount'],
                      spendingPct: totalSpending == 0
                          ? 0
                          : (recentTx['amount'] as double) / totalSpending,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
