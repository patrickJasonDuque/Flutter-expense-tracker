import 'package:flutter/material.dart';

import './transaction_list.dart';

import '../models/transaction.dart';

class UserTransaction extends StatelessWidget {
  final List<Transaction> transactions;
  final Function onDeleteTransaction;

  const UserTransaction(this.transactions, this.onDeleteTransaction);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return transactions.isEmpty
          ? Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  'No expenses yet.',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 50,
                ),
                // Container(
                //   height: constraints.maxHeight * .6,
                //   child: Image.asset(
                //     'assets/images/ocean.jfif',
                //     fit: BoxFit.cover,
                //   ),
                // )
              ],
            )
          : Container(
              child: TransactionList(
                transactions: transactions,
                onDeleteTransaction: onDeleteTransaction,
              ),
            );
    });
  }
}
