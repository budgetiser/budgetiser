import 'dart:developer';

class Profiler {
  Profiler._privateConstructor();

  static final Profiler instance = Profiler._privateConstructor();

  Map<String, Map<String, dynamic>> timeMeasurements = {};
  String lastStarted = "";

  void start(String eventName) {
    bool add = false;
    if (!timeMeasurements.containsKey(eventName)) {
      timeMeasurements[eventName] = {
        "name": eventName,
        "start": <int>[],
        "end": <int>[],
        "count": 0,
      };
      add = true;
    } else if (timeMeasurements[eventName]!['start'].length >
        timeMeasurements[eventName]!['end'].length) {
      print("Time measure error: Event '$eventName' not finished before reassignment!");
    } else {
      add = true;
    }

    // Start measurement as late as possible
    if (add) {
      lastStarted = eventName;
      timeMeasurements[eventName]!['start'].add(DateTime.now().microsecondsSinceEpoch);
    }
  }

  void end([String? eventName]) {
    String name = eventName ?? lastStarted;
    // End measurement as fast as possible
    final tempTime = DateTime.now().microsecondsSinceEpoch;
    if (!timeMeasurements.containsKey(name)) {
      print("Time measure error: Event '$name' not defined!");
    } else if (timeMeasurements[name]!['end'].length >=
        timeMeasurements[name]!['start'].length) {
      print("Time measure error: Event '$name' not started before reassignment!");
    } else {
      timeMeasurements[name]!['end'].add(tempTime);
      timeMeasurements[name]!['count']++;
    }
    analyseTimeMeasurements();
  }

  void analyseTimeMeasurements() {
    // Analyze time measurements and print them in a table.
    // Multiple events with the same name are averaged.

    print('Name\tAvg. [ms]\tMin. [ms]\tMax. [ms]\tOccurrences [compl.]');
    timeMeasurements.forEach((key, event) {
      final List<int> startTimes = event['start'];
      final List<int> endTimes = event['end'];
      final List<int> timings = [];

      if (startTimes.length != endTimes.length) {
        print("Time measure error: Event '$key' has different amounts of values for start and end times!");
        return;
      }

      for (int i = 0; i < startTimes.length; i++) {
        final timing = (endTimes[i] - startTimes[i]);
        // Exclude 0 values
        if (timing >= 0) {
          final timingInMs = timing / 1000;
          timings.add(timingInMs.toInt());
        }
      }

      final minTiming = timings.isEmpty ? 0 : timings.reduce((a, b) => a < b ? a : b);
      final maxTiming = timings.isEmpty ? 0 : timings.reduce((a, b) => a > b ? a : b);
      final avgTiming = timings.isEmpty ? 0 : timings.reduce((a, b) => a + b) / timings.length;

      print('$key\t${avgTiming.toStringAsFixed(2)}\t${minTiming.toStringAsFixed(2)}\t${maxTiming.toStringAsFixed(2)}\t${event['count']}');
    });
  }
}