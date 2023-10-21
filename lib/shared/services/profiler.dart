import 'package:flutter/foundation.dart';

class Profiler {
  Profiler._privateConstructor();

  static final Profiler instance = Profiler._privateConstructor();

  Map<String, Map<String, dynamic>> timeMeasurements = {};
  List<String> lastStarted = [];

  void start(String eventName) {
    bool add = false;
    if (!timeMeasurements.containsKey(eventName)) {
      timeMeasurements[eventName] = {
        'name': eventName,
        'start': <int>[],
        'end': <int>[],
        'count': 0,
      };
      add = true;
    } else if ((timeMeasurements[eventName]!['start'] as List<int>).length >
        (timeMeasurements[eventName]!['end'] as List<int>).length) {
      throw 'Time measure error: Event "$eventName" not finished before reassignment!';
    } else {
      add = true;
    }

    // Start measurement as late as possible
    if (add) {
      lastStarted.add(eventName);
      (timeMeasurements[eventName]!['start'] as List<int>)
          .add(DateTime.now().microsecondsSinceEpoch);
    }
  }

  void end([String? eventName]) {
    // End measurement as fast as possible
    final tempTime = DateTime.now().microsecondsSinceEpoch;
    String name = eventName ?? lastStarted.removeLast();
    if (!timeMeasurements.containsKey(name)) {
      throw 'Time measure error: Event "$name" not defined!';
    } else if ((timeMeasurements[name]!['end'] as List<int>).length >=
        (timeMeasurements[name]!['start'] as List<int>).length) {
      throw 'Time measure error: Event "$name" not started before reassignment!';
    } else {
      (timeMeasurements[name]!['end'] as List<int>).add(tempTime);
      timeMeasurements[name]!['count'] =
          (timeMeasurements[name]!['count'] as int) + 1;
    }
  }

  void endAll() {
    for (int i = 0; i < lastStarted.length; i++) {
      end(lastStarted.removeLast());
    }
  }

  void analyseTimeMeasurements() {
    // Analyze time measurements and print them in a table.
    // Multiple events with the same name are averaged.
    if (kDebugMode) {
      print(
          'Name\tAvg. [ms]\tMin. [ms]\tMax. [ms]\tOccurrences [compl.]\tTotal Time [ms]');
    }
    timeMeasurements.forEach((key, event) {
      final List<int> startTimes = event['start'];
      final List<int> endTimes = event['end'];
      final List<int> timings = [];

      if (startTimes.length != endTimes.length) {
        throw 'Time measure error: Event "$key" has different amounts of values for start and end times!';
      }

      for (int i = 0; i < startTimes.length; i++) {
        final timing = (endTimes[i] - startTimes[i]);
        // Exclude 0 values
        if (timing >= 0) {
          final timingInMs = timing / 1000;
          timings.add(timingInMs.toInt());
        }
      }

      final minTiming =
          timings.isEmpty ? 0 : timings.reduce((a, b) => a < b ? a : b);
      final maxTiming =
          timings.isEmpty ? 0 : timings.reduce((a, b) => a > b ? a : b);
      final avgTiming = timings.isEmpty
          ? 0
          : timings.reduce((a, b) => a + b) / timings.length;
      final totalTiming = avgTiming * event['count'];

      if (kDebugMode) {
        print(
            '$key\t${avgTiming.toStringAsFixed(2)}\t${minTiming.toStringAsFixed(2)}\t${maxTiming.toStringAsFixed(2)}\t${event['count']}\t${totalTiming.toStringAsFixed(2)}');
      }
    });
  }
}
