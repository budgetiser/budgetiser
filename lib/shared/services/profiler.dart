import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Profiler {
  Profiler._privateConstructor();

  static final Profiler instance = Profiler._privateConstructor();

  Map<String, Map<String, dynamic>> timeMeasurements = {};
  List<String> lastStarted = [];

  var uuid = const Uuid();

  void start(String eventName) {
    String id = uuid.v1();
    timeMeasurements[id] = {'id': id, 'name': eventName, 'start': 0, 'end': 0};

    // Start measurement as late as possible
    lastStarted.add(id);
    timeMeasurements[id]!['start'] = DateTime.now().microsecondsSinceEpoch;
  }

  void end([String? id]) {
    // End measurement as fast as possible
    final tempTime = DateTime.now().microsecondsSinceEpoch;
    if (id == null) {
      id = lastStarted.removeLast();
    } else {
      lastStarted.removeWhere((element) => element == id);
    }

    if (!timeMeasurements.containsKey(id)) {
      throw 'Time measure error: Event "$id" not defined!';
    } else {
      timeMeasurements[id]!['end'] = tempTime;
    }
  }

  void endAll() {
    for (int i = 0; i < lastStarted.length; i++) {
      end(lastStarted.removeLast());
    }
  }

  void analyseTimeMeasurements({bool reset = true}) {
    // Analyze time measurements and print them in a table.
    // Multiple events with the same name are averaged.
    if (kDebugMode) {
      print(
          'Name\tAvg. [ms]\tMin. [ms]\tMax. [ms]\tOccurrences [compl.]\tTotal Time [ms]');
    }
    Map<String, Map<String, dynamic>> grouped_measures = {};

    timeMeasurements.forEach((key, event) {
      final String name = event['name'];
      final duration = event['end'] - event['start'];
      if (grouped_measures.containsKey(name)) {
        (grouped_measures[name]!['durations'] as List<int>).add(duration);
        grouped_measures[name]!['occurences'] =
            (grouped_measures[name]!['occurences'] as int) + 1;
      } else {
        grouped_measures[name] = {
          'durations': [duration],
          'occurences': 1
        };
      }
    });

    grouped_measures.forEach((key, value) {
      final List<int> durations = (value['durations'] as List<int>);
      final int occurences = value['occurences'];
      final minTiming =
          durations.isEmpty ? 0 : durations.reduce((a, b) => a < b ? a : b);
      final maxTiming =
          durations.isEmpty ? 0 : durations.reduce((a, b) => a < b ? a : b);
      final totalTiming = durations.reduce((a, b) => a + b);
      final avgTiming = durations.isEmpty ? 0 : totalTiming / occurences;
      if (kDebugMode) {
        print(
            '$key\t${avgTiming.toStringAsFixed(2)}\t${minTiming.toStringAsFixed(2)}\t${maxTiming.toStringAsFixed(2)}\t$occurences\t${totalTiming.toStringAsFixed(2)}');
      }
    });

    if (reset) {
      endAll();
      lastStarted.clear();
      timeMeasurements.clear();
    }
  }
}
