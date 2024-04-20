import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/material.dart';

enum DurationEnum { day, week, month, year, allTime }

class SegmentedDurationPicker extends StatefulWidget {
  /// [callback] returns startDate when a new selection is made
  const SegmentedDurationPicker({
    super.key,
    required this.callback,
    this.initialSelected = DurationEnum.allTime,
  });
  final Function(DateTime) callback;
  final DurationEnum initialSelected;

  @override
  State<SegmentedDurationPicker> createState() =>
      _SegmentedDurationPickerState();
}

class _SegmentedDurationPickerState extends State<SegmentedDurationPicker> {
  late DurationEnum _currentSelected;

  @override
  void initState() {
    _currentSelected = widget.initialSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DurationEnum>(
      showSelectedIcon: false,
      segments: const <ButtonSegment<DurationEnum>>[
        ButtonSegment<DurationEnum>(
          value: DurationEnum.day,
          label: Text('1 Day'),
        ),
        ButtonSegment<DurationEnum>(
          value: DurationEnum.week,
          label: Text('7 Days'),
        ),
        ButtonSegment<DurationEnum>(
          value: DurationEnum.month,
          label: Text('1 Month'),
        ),
        ButtonSegment<DurationEnum>(
          value: DurationEnum.year,
          label: Text('1 Year'),
        ),
        ButtonSegment<DurationEnum>(
          value: DurationEnum.allTime,
          label: Text('All time'),
        ),
      ],
      selected: <DurationEnum>{_currentSelected},
      onSelectionChanged: (Set<DurationEnum> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          _currentSelected = newSelection.first;

          DateTime startDate = today();
          switch (_currentSelected) {
            case DurationEnum.day:
              break;
            case DurationEnum.week:
              startDate = startDate.subtract(const Duration(days: 6));
            case DurationEnum.month:
              startDate =
                  DateTime(startDate.year, startDate.month - 1, startDate.day);
            case DurationEnum.year:
              startDate =
                  DateTime(startDate.year - 1, startDate.month, startDate.day);
            case DurationEnum.allTime:
              startDate = DateTime(2000);
            default:
            // startDate = today();
          }
          widget.callback(startDate);
        });
      },
    );
  }
}
