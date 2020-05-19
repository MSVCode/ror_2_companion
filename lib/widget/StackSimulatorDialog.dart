import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ror_2_companion/helper/changeCase.dart';
import 'package:ror_2_companion/model/Item.dart';
import 'package:ror_2_companion/widget/CustomDetailRow.dart';

class StackSimulatorDialog extends StatefulWidget {
  final List<ItemStatus> statusList;

  StackSimulatorDialog({this.statusList});

  @override
  StackSimulatorDialogState createState() => StackSimulatorDialogState();
}

class StackSimulatorDialogState extends State<StackSimulatorDialog> {
  TextEditingController _countController;
  final numberRegex = RegExp(r"[\d\-\+\.]");
  final nonNumberRegex = RegExp(r"[^\d\-\+\.]");
  int _numberOfItem = 1;

  @override
  void initState() {
    super.initState();

    _countController = TextEditingController(text: "1");
  }

  void _changeNumberOfItem(int diff) {
    int newCount = _numberOfItem += diff;
    setState(() {
      _numberOfItem = newCount < 1 ? 1 : newCount;
    });

    _countController.text = _numberOfItem.toString();
  }

  /// Input is scalar, not percent
  double calculateLinear(double initial, double added) {
    int numberOfItem = _numberOfItem < 0 ? 0 : _numberOfItem;
    return initial + added * (numberOfItem - 1);
  }

  /// Input is scalar, not percent
  double calculateExponential(double initial, double added) {
    int numberOfItem = _numberOfItem < 0 ? 0 : _numberOfItem;
    return (1 + initial) * pow(1 + added, (numberOfItem - 1));
  }

  /// initial and added is the same
  ///
  /// Input is scalar, not percent
  double calculateHyperbolic(double added) {
    int numberOfItem = _numberOfItem < 0 ? 0 : _numberOfItem;
    return 1 - 1 / (1 + added * numberOfItem);
  }

  ///special stacking
  double calculateBandolier() {
    int numberOfItem = _numberOfItem < 0 ? 0 : _numberOfItem;
    return 1 - 1 / pow(numberOfItem + 1, 0.33);
  }

  ///Data comes in string
  ///
  ///Calculate result for a single status
  String calculateResult(
      String initialText, String addedText, STACK_TYPE stackType) {
    if (initialText == null || addedText == null) return "-";

    bool initialIsPercent = initialText.contains("%");
    bool addedIsPercent = addedText.contains("%");
    String measurement =
        nonNumberRegex.allMatches(initialText).map((m) => m[0]).join();
    String numInitial =
        numberRegex.allMatches(initialText).map((m) => m[0]).join();
    String numAdded = numberRegex.allMatches(addedText).map((m) => m[0]).join();

    double initial = double.tryParse(numInitial);
    double added = double.tryParse(numAdded);

    // bool isNegative = added < 0;

    //convert to positive for calculation
    // if (isNegative) {
    //   added *= -1;
    // }

    if (initialIsPercent) {
      initial /= 100;
    }
    if (addedIsPercent) {
      added /= 100;
    }

    double result = 0;
    switch (stackType) {
      case STACK_TYPE.BANDOLIER:
        result = calculateBandolier();
        break;
      case STACK_TYPE.EXPONENTIAL:
        result = calculateExponential(initial, added);
        break;
      case STACK_TYPE.HYPERBOLIC:
        result = calculateHyperbolic(added);
        break;
      case STACK_TYPE.LINEAR:
        result = calculateLinear(initial, added);
        break;
      // case STACK_TYPE.RUSTED_KEY: //too special
      //   result = calculateBandolier();
      //   break;
      default:
        result = initial;
        break;
    }

    //result based on initial
    if (initialIsPercent) result *= 100;

    // if (isNegative) result *= -1;

    // assumes right-side measurement
    return "${result.toStringAsFixed(0)}$measurement";
  }

  List<Widget> buildResultStatus() {
    var statList = widget.statusList.map<Widget>((stat) {
      return CustomDetailRow(
        flexList: [1, 1, 1],
        children: <Widget>[
          Text(stat.type),
          Text(enumToTitle(stat.stackType)),
          Text(
            calculateResult(
                stat.initialAmount, stat.addedAmount, stat.stackType),
            textAlign: TextAlign.right,
          )
        ],
      );
    }).toList();

    return [
      CustomDetailRow(
        flexList: [1, 1, 1],
        children: <Widget>[
          Text("Type"),
          Text("Stack Type"),
          Text(
            "Result",
            textAlign: TextAlign.right,
          )
        ],
      ),
      ...statList
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Stack Simulation"),
      content: Container(
        width: MediaQuery.of(context).size.width - 20,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Number of Item"),
              controller: _countController,
              keyboardType: TextInputType.number,
              onChanged: (val) =>
                  setState(() => _numberOfItem = int.tryParse(val) ?? 0),
            ),
            SizedBox(
              height: 16,
            ),
            ButtonTheme(
              minWidth: (MediaQuery.of(context).size.width - 200) / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: Text("-10"),
                    onPressed: () => _changeNumberOfItem(-10),
                  ),
                  RaisedButton(
                    child: Text("-1"),
                    onPressed: () => _changeNumberOfItem(-1),
                  ),
                  RaisedButton(
                    child: Text("+1"),
                    onPressed: () => _changeNumberOfItem(1),
                  ),
                  RaisedButton(
                    child: Text("+10"),
                    onPressed: () => _changeNumberOfItem(10),
                  )
                ],
              ),
            ),
            Divider(
              height: 16,
            ),
            Text(
              "Status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            ...buildResultStatus()
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
