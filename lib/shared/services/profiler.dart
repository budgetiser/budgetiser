import 'dart:developer';

import 'package:uuid/uuid.dart';

class Profiler {
  Profiler._privateConstructor();

  static final Profiler instance = Profiler._privateConstructor();

  final _timeline = TimelineTask(filterKey: 'profiler-UID-993e63f6');

  var uuid = const Uuid();

  void start(String eventName) {
    _timeline.start(eventName);
  }

  void end() {
    _timeline.finish();
  }
}
