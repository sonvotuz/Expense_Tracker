import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  // String titleInput, amountInput;
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final Function addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: titleController,
            // onChanged: (value) => titleInput = value,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            controller: amountController,
            // onChanged: (value) => amountInput = value,
          ),
          TextButton(
            child: Text('Add Transaction'),
            style: TextButton.styleFrom(
              primary: Colors.purple,
            ),
            onPressed: () {
              addNewTransaction(
                  titleController.text, double.parse(amountController.text));
            },
          )
        ]),
      ),
    );
  }
}
