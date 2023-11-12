import 'dart:developer';

class Profiler {
  Profiler._privateConstructor();

  static final Profiler instance = Profiler._privateConstructor();

  final _timeline = TimelineTask(filterKey: 'profiler-UID-993e63f6');

  void start(String eventName) {
    _timeline.start(eventName);
  }

  void end() {
    _timeline.finish();
  }
}
