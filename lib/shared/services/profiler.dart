class Profiler {
  Profiler._privateConstructor();

  static final Profiler instance = Profiler._privateConstructor();

  var runtimes = [];
  var log = [];
  int level = 0;

  void start(String name){
    runtimes.add({
      "level": runtimes.length,
      "name": name,
      "stopwatch": Stopwatch(),
      "runtime": 0
    });
    runtimes.last["stopwatch"].start();
  }

  void stop(){
    runtimes.last["stopwatch"].stop();
    runtimes.last["runtime"] = runtimes.last["stopwatch"].elapsedMilliseconds;
    log.add(runtimes.last);
    runtimes.removeLast();
    print(log);
  }
}