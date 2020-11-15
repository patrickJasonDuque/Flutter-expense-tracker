import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionInput extends StatefulWidget {
  final Function onAddTransaction;
  TransactionInput({this.onAddTransaction});

  @override
  _TransactionInputState createState() => _TransactionInputState();
}

class _TransactionInputState extends State<TransactionInput> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _date;

  void _addTransactionHandler() {
    if (_titleController.text.isEmpty ||
        double.parse(_amountController.text) <= 0 ||
        _date == null) {
      return;
    }
    widget.onAddTransaction(
        _titleController.text, double.parse(_amountController.text), _date);
    Navigator.of(context).pop();
  }

  void _getDatePicker() async {
    DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().subtract(Duration(days: 6)),
        lastDate: new DateTime.now());
    setState(() {
      _date = datePicked;
    });
    if (FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.fromLTRB(
              10, 10, 10, MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                textCapitalization: TextCapitalization.words,
                controller: _titleController,
                cursorColor: Colors.greenAccent[200],
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1)),
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.green),
                ),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.greenAccent[200],
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1)),
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.green),
                ),
                onSubmitted: (_) => _addTransactionHandler(),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _date == null
                          ? 'No Date'
                          : 'Picked Date: ${DateFormat.MMMMd().format(_date)}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  FlatButton(
                    onPressed: _getDatePicker,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    textColor: Theme.of(context).primaryColorDark,
                  ),
                ],
              ),
              RaisedButton(
                  onPressed: _addTransactionHandler,
                  child: Text('Add Transaction'),
                  color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).primaryColor)
            ],
          ),
        ),
      ),
    );
  }
}
