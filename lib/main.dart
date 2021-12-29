import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage2(),
    );
  }
}

final valueProvider = Provider<int>((ref) {
  return 356;
});

final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    //final value = ref.watch(valueProvider);
    final counter = ref.watch(counterStateProvider.state).state;
    ref.listen<int>(counterStateProvider, (count, count1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Value is $count1'),
      ));
    });
    return Scaffold(
      body: Center(
        child: Text(
          'Value: $counter',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterStateProvider.state).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Clock extends StateNotifier<DateTime> {
  Clock() : super(DateTime.now()) {
    final Timer _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = DateTime.now();
    });

    @override
    void dispose() {
      _timer.cancel();
      super.dispose();
    }
  }
}

final clockProvier = StateNotifierProvider<Clock, DateTime>((ref) {
  return Clock();
});

class MyHomePage2 extends ConsumerWidget {
  const MyHomePage2({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final currentTime = ref.watch(clockProvier);
    final timeFormatted = DateFormat.Hms().format(currentTime);
    return Scaffold(
      body: Center(child: Text(timeFormatted)),
    );
  }
}

final futureProvider = FutureProvider<int>((ref) async {
  return Future.value(36);
});

final streamProvider = StreamProvider<int>((ref) async* {
  yield* Stream.fromIterable([36, 72]);
});

class MyHomePage3 extends ConsumerWidget {
  const MyHomePage3({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final streamAsyncValue = ref.watch(streamProvider);
    final futureAsyncValue = ref.watch(futureProvider);
    return Scaffold(
      body: Column(
        children: [
          streamAsyncValue.when(
            data: (data) => Text("Value: $data"),
            error: (e, st) => Text('Error $e'),
            loading: () => const CircularProgressIndicator(),
          ),
          futureAsyncValue.when(
            data: (data) => Text("Value: $data"),
            error: (e, st) => Text('Error $e'),
            loading: () => const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
