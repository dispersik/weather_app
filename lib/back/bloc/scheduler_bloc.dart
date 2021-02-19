import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocScheduler extends Bloc<Task, Task> {
  BlocScheduler() : super(null) {
    print('scheduler contructor');
    sleep(Duration(seconds: 3));
    print('timer ticking');
  }

  int _temp=0;

  @override
  Stream<Task> mapEventToState(Task task) async* {
    // var t = Timer.periodic(duration, (timer) { });
    // t.cancel();
  }
}


class Task {
  Task({ this.event,
    this.targetBloc,
    this.delayTime});

  final dynamic event;
  final dynamic delayTime;
  final dynamic targetBloc;
}
