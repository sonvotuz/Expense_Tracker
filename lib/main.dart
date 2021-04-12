import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracking App',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'QuickSand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          )),
      home: ExpenseTrackingApp(),
    );
  }
}

class ExpenseTrackingApp extends StatefulWidget {
  @override
  _ExpenseTrackingAppState createState() => _ExpenseTrackingAppState();
}

class _ExpenseTrackingAppState extends State<ExpenseTrackingApp> {
  final List<Transaction> _userTransactions = [];

  bool _showchart = false;
  List<Transaction> get _recentTransaction {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime pickedDate) {
    final newT = Transaction(
        title: title,
        amount: amount,
        date: pickedDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newT);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final ObstructingPreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Tracking App'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add))
            ]))
        : AppBar(
            title: Text('Expense Tracking App'),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );

    final txList = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final body = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(children: [
              Text('Show Chart', style: Theme.of(context).textTheme.headline6),
              Switch.adaptive(
                activeColor: Theme.of(context).accentColor,
                value: _showchart,
                onChanged: (val) {
                  setState(() {
                    _showchart = val;
                  });
                },
              )
            ]),
          if (!isLandscape)
            Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransaction)),
          if (!isLandscape) txList,
          if (isLandscape)
            _showchart
                ? Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransaction))
                : txList,
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
