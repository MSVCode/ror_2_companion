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
  final numberRegex = RegExp(r"\d");
  final nonNumberRegex = RegExp(r"[^\d]");
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
    return initial + added * (_numberOfItem - 1);
  }

  /// initial and added is the same
  ///
  /// Input is scalar, not percent
  double calculateExponential(double added) {
    return pow(1 + added, (_numberOfItem - 1));
  }

  /// initial and added is the same
  /// 
  /// Input is scalar, not percent
  double calculateHyperbolic(double added) {
    return 1 - 1 / (1 + added * (_numberOfItem - 1));
  }

  ///special stacking
  double calculateBandolier() {
    return 1 - 1 / pow(_numberOfItem, 0.33);
  }

  ///Data comes in string
  ///
  ///Calculate result for a single status
  String calculateResult(
      String initialText, String addedText, STACK_TYPE stackType) {
    bool isPercent = initialText.contains("%");
    String measurement =
        nonNumberRegex.allMatches(initialText).map((m) => m[0]).join();
    String numInitial =
        numberRegex.allMatches(initialText).map((m) => m[0]).join();
    String numAdded =
        numberRegex.allMatches(initialText).map((m) => m[0]).join();

    double initial = double.tryParse(numInitial);
    double added = double.tryParse(numAdded);

    if (isPercent) {
      initial /= 100;
      added /= 100;
    }

    double result = 0;
    switch (stackType) {
      case STACK_TYPE.BANDOLIER:
        result = calculateBandolier();
        break;
      case STACK_TYPE.EXPONENTIAL:
        result = calculateExponential(added);
        break;
      case STACK_TYPE.HYPERBOLIC:
        result = calculateHyperbolic(added);
        break;
      case STACK_TYPE.LINEAR:
        result = calculateLinear(initial, added);
        break;
      case STACK_TYPE.NONE:
        result = initial;
        break;
      // case STACK_TYPE.RUSTED_KEY: //too special
      //   result = calculateBandolier();
      //   break;
      default:
        break;
    }

    if (isPercent) result *= 100;

    // result = result.roundToDouble();

    // assumes right-side measurement
    return "${result.toStringAsFixed(0)}$measurement";
  }

  List<Widget> buildResultStatus() {
    return widget.statusList.map<Widget>((stat) {
      return CustomDetailRow(
        flexList: [1, 1, 1],
        children: <Widget>[
          Text(stat.type),
          Text(enumToTitle(stat.stackType)),
          Text(calculateResult(
              stat.initialAmount, stat.addedAmount, stat.stackType))
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Stack Simulation"),
      content: Container(
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
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
