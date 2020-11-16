import 'package:flutter/material.dart';
import './transaction_card.dart';

class TransactionList extends StatelessWidget {
  final List transactions;
  final Function onDeleteTransaction;

  const TransactionList({this.transactions, this.onDeleteTransaction});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, i) => TransactionCard(
        amount: transactions[i].amount,
        title: transactions[i].title,
        date: transactions[i].date,
        onRemoveTransaction: () => onDeleteTransaction(transactions[i].id),
      ),
    );
    // return ListView(
    //   children: [
    //     ...transactions.map((tx) => TransactionCard(
    //           amount: tx.amount,
    //           title: tx.title,
    //           date: tx.date,
    //         ))
    //   ],
    // );
  }
}
