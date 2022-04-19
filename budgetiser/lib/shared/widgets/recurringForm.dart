import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/services/notification/recurringNotification.dart';
import 'package:budgetiser/shared/widgets/picker/datePicker.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class RecurringForm extends StatefulWidget {
  RecurringForm({
    Key? key,
    required this.initialRecurringData,
  }) : super(key: key);

  RecurringData initialRecurringData;

  @override
  State<RecurringForm> createState() => _RecurringFormState();
}

enum IntervalType {
  fixedPointOfTime,
  fixedInterval,
}

class _RecurringFormState extends State<RecurringForm> {
  bool isRecurring = false;
  DateTime startDate = DateTime.now();
  IntervalType _selectedIntervalType = IntervalType.fixedInterval;
  var fixedPointOfTimeAmountController = TextEditingController();
  var fixedIntervalAmountController = TextEditingController();
  var repetitionsController = TextEditingController();
  String fixedPointOfTimeUnit = "week";
  String fixedIntervalUnit = "day";
  DateTime? enddate;

  List<DropdownMenuItem<String>> get dropdownItemsFixedPointOfTimeUnit {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("of a week"), value: "week"),
      const DropdownMenuItem(child: Text("of a month"), value: "month"),
      const DropdownMenuItem(child: Text("of a year"), value: "year"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsFixedIntervalUnit {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("day"), value: "day"),
      const DropdownMenuItem(child: Text("week"), value: "week"),
      const DropdownMenuItem(child: Text("month"), value: "month"),
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialRecurringData != null) {
      isRecurring = widget.initialRecurringData.isRecurring;
      startDate = widget.initialRecurringData.startDate;
      if (isRecurring) {
        _selectedIntervalType = widget.initialRecurringData.intervalType!;
        fixedIntervalUnit = widget.initialRecurringData.intervalUnit!;
        fixedPointOfTimeAmountController.text =
            widget.initialRecurringData.intervalAmount!.toString();
      }
    }
    _calculateEndDate();
  }

  void _calculateEndDate() {
    if (fixedIntervalAmountController.text.isEmpty &&
            _selectedIntervalType == IntervalType.fixedInterval ||
        fixedPointOfTimeAmountController.text.isEmpty &&
            _selectedIntervalType == IntervalType.fixedPointOfTime ||
        repetitionsController.text.isEmpty) {
      enddate = null;
      return;
    }

    if (_selectedIntervalType == IntervalType.fixedPointOfTime) {
      switch (fixedPointOfTimeUnit) {
        case "week":
          Duration untilFirstPointOfTime = Duration(
              days: (int.parse(fixedPointOfTimeAmountController.text) -
                          startDate.weekday) >=
                      0
                  ? int.parse(fixedPointOfTimeAmountController.text) -
                      startDate.weekday
                  : 7 -
                      (startDate.weekday -
                          int.parse(fixedPointOfTimeAmountController.text)));
          Duration fromRepetitions =
              Duration(days: 7 * (int.parse(repetitionsController.text) - 1));
          enddate = startDate.add(untilFirstPointOfTime + fromRepetitions);
          break;
        case "month":
          Duration untilFirstPointOfTime = Duration(
              days: int.parse(fixedPointOfTimeAmountController.text) -
                          startDate.day >=
                      0
                  ? int.parse(fixedPointOfTimeAmountController.text) -
                      startDate.day
                  : Jiffy(startDate).daysInMonth -
                      startDate.day +
                      int.parse(fixedPointOfTimeAmountController.text));
          enddate = startDate.add(untilFirstPointOfTime);
          enddate = Jiffy(enddate)
              .add(months: int.parse(repetitionsController.text))
              .dateTime;
          break;
        case "year":
          Duration untilFirstPointOfTime = Duration(
            days: (int.parse(fixedPointOfTimeAmountController.text) -
                        Jiffy(startDate).dayOfYear >=
                    0)
                ? int.parse(fixedPointOfTimeAmountController.text) -
                    Jiffy(startDate).dayOfYear
                : ((Jiffy(startDate).isLeapYear == true) ? 366 : 365) -
                    Jiffy(startDate).dayOfYear +
                    int.parse(fixedPointOfTimeAmountController.text),
          );
          break;
        default:
          print("Error in _calculateEndDate: unknown intervalMode");
      }
    } else {
      switch (fixedIntervalUnit) {
        case "day":
          enddate = startDate.add(
              Duration(days: int.parse(fixedIntervalAmountController.text)) *
                  int.parse(repetitionsController.text));
          break;
        case "week":
          enddate = startDate.add(Duration(
              days: int.parse(fixedIntervalAmountController.text) *
                  int.parse(repetitionsController.text) *
                  7));
          break;
        case "month":
          enddate = Jiffy(startDate)
              .add(
                  months: int.parse(fixedIntervalAmountController.text) *
                      int.parse(repetitionsController.text))
              .dateTime;
          break;
        default:
          print(
              "Error in _calculateEndDate(fixedInterval): unknown intervalMode");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0, right: 8, top: 13),
          child: Row(children: [
            Flexible(
              child: DatePicker(
                label: "start",
                initialDate: startDate,
                onDateChangedCallback: (date) {
                  setState(() {
                    startDate = date;
                    _calculateEndDate();
                  });
                  _sendRecurringNotification();
                },
              ),
            ),
            Checkbox(
              value: isRecurring,
              onChanged: (bool? newValue) {
                setState(() {
                  isRecurring = newValue!;
                  _calculateEndDate();
                  _sendRecurringNotification();
                });
              },
            ),
            const Text("recurring"),
          ]),
        ),
        if (isRecurring)
          Column(
            children: [
              Row(children: <Widget>[
                Radio(
                  onChanged: (IntervalType? value) {
                    setState(() {
                      _selectedIntervalType = value!;
                      _calculateEndDate();
                      _sendRecurringNotification();
                    });
                  },
                  groupValue: _selectedIntervalType,
                  value: IntervalType.fixedPointOfTime,
                ),
                const Text("always on the: "),
                SizedBox(
                  width: 40,
                  height: 30,
                  child: TextFormField(
                    controller: fixedPointOfTimeAmountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(
                  child: DropdownButton(
                    value: fixedPointOfTimeUnit,
                    items: dropdownItemsFixedPointOfTimeUnit,
                    onChanged: (String? value) {
                      setState(() {
                        fixedPointOfTimeUnit = value!;
                        _calculateEndDate();
                        _sendRecurringNotification();
                      });
                    },
                  ),
                )
              ]),
              Row(children: <Widget>[
                Radio(
                  onChanged: (IntervalType? value) {
                    setState(() {
                      _selectedIntervalType = value!;
                      _calculateEndDate();
                      _sendRecurringNotification();
                    });
                  },
                  groupValue: _selectedIntervalType,
                  value: IntervalType.fixedInterval,
                ),
                const Text("every: "),
                SizedBox(
                  width: 40,
                  height: 30,
                  child: TextFormField(
                    controller: fixedIntervalAmountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                  ),
                ),
                SizedBox(
                  child: DropdownButton(
                    value: fixedIntervalUnit,
                    items: dropdownItemsFixedIntervalUnit,
                    onChanged: (String? value) {
                      setState(() {
                        fixedIntervalUnit = value!;
                        _calculateEndDate();
                        _sendRecurringNotification();
                      });
                    },
                  ),
                )
              ]),
              Row(
                children: [
                  const Text("Repetitions: "),
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: TextFormField(
                      controller: repetitionsController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                      "Ends on: ${enddate != null ? enddate.toString().substring(0, 10) : ""}"),
                ],
              ),
            ],
          ),
      ],
    );
  }

  void _sendRecurringNotification() {
    RecurringNotification(
      RecurringData(
        startDate: startDate,
        isRecurring: isRecurring,
        intervalType: _selectedIntervalType,
        intervalUnit: fixedIntervalUnit,
        intervalAmount: fixedPointOfTimeAmountController.text.isEmpty &&
                    _selectedIntervalType == IntervalType.fixedPointOfTime ||
                fixedIntervalAmountController.text.isEmpty &&
                    _selectedIntervalType == IntervalType.fixedInterval
            ? null
            : _selectedIntervalType == IntervalType.fixedPointOfTime
                ? int.parse(fixedPointOfTimeAmountController.text)
                : int.parse(fixedIntervalAmountController.text),
        endDate: enddate,
      ),
    ).dispatch(context);
  }
}
