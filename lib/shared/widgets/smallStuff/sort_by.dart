import 'package:budgetiser/shared/widgets/smallStuff/divider_with_text.dart';
import 'package:budgetiser/shared/widgets/smallStuff/radio_item_clickable.dart';
import 'package:flutter/material.dart';

enum SortedByEnum {
  nameAscending,
  nameDescending,
  numberAscending,
  numberDescending,
}

SortedByEnum stringToEnumSortedByEnum(String stringValue) {
  return SortedByEnum.values.firstWhere(
    (enumValue) => enumValue.toString() == stringValue,
  );
}

/// Clickable Icon with dialog
///
/// calls [onChangedCallback] after a new sort is selected
///
/// uses [SortedByEnum]
///
/// TODO: find a way to not pop the dialog with every tap (currently the dialog does not update after setState)
class SortByIconWidget extends StatefulWidget {
  final Function(SortedByEnum) onChangedCallback;
  final SortedByEnum initialSort;

  const SortByIconWidget({
    required this.onChangedCallback,
    this.initialSort = SortedByEnum.nameAscending,
    super.key,
  });

  @override
  State<SortByIconWidget> createState() => _SortByIconWidgetState();
}

class _SortByIconWidgetState extends State<SortByIconWidget> {
  bool _isAscending = false;
  bool _isSortedByName = true;
  GlobalKey<_SortByIconWidgetState> dialogKey =
      GlobalKey<_SortByIconWidgetState>();

  void onNewSortSelected() {
    late SortedByEnum currentSelectedSort;
    if (!_isAscending && _isSortedByName) {
      currentSelectedSort = SortedByEnum.nameDescending;
    } else if (_isAscending && _isSortedByName) {
      currentSelectedSort = SortedByEnum.nameAscending;
    } else if (!_isAscending && !_isSortedByName) {
      currentSelectedSort = SortedByEnum.numberDescending;
    } else if (_isAscending && !_isSortedByName) {
      currentSelectedSort = SortedByEnum.numberAscending;
    }
    widget.onChangedCallback(currentSelectedSort);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.initialSort) {
      case SortedByEnum.nameAscending:
        _isAscending = true;
        _isSortedByName = true;
        break;
      case SortedByEnum.nameDescending:
        _isAscending = false;
        _isSortedByName = true;
        break;
      case SortedByEnum.numberAscending:
        _isAscending = true;
        _isSortedByName = false;
        break;
      case SortedByEnum.numberDescending:
        _isAscending = false;
        _isSortedByName = false;
        break;
      default:
        throw ArgumentError();
    }
    print('widget init build ${widget.initialSort}');
    return IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () {
        showSortByDialog(context);
      },
    );
  }

  Future<dynamic> showSortByDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Sort by'),
          alignment: Alignment.topRight,
          key: dialogKey,
          children: [
            RadioItemClickable(
              value: true,
              title: 'Name',
              groupValue: _isSortedByName,
              onChangedCallback: (value) {
                Navigator.of(context).pop();
                setState(() {
                  _isSortedByName = value;
                });
                onNewSortSelected();
              },
            ),
            RadioItemClickable(
              value: false,
              title: 'Balance',
              groupValue: _isSortedByName,
              onChangedCallback: (value) {
                Navigator.of(context).pop();
                setState(() {
                  _isSortedByName = value;
                });
                onNewSortSelected();
              },
            ),
            const DividerWithText('Order', leftWidth: 55),
            RadioItemClickable(
              value: true,
              title: 'Ascending',
              groupValue: _isAscending,
              onChangedCallback: (value) {
                Navigator.of(context).pop();
                setState(() {
                  _isAscending = value;
                });
                onNewSortSelected();
              },
            ),
            RadioItemClickable(
              value: false,
              title: 'Descending',
              groupValue: _isAscending,
              onChangedCallback: (value) {
                Navigator.of(context).pop();
                setState(() {
                  _isAscending = value;
                });
                onNewSortSelected();
              },
            ),
          ],
        );
      },
    );
  }
}
