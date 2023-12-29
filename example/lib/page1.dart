// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';

class VelocityAverage {
  VelocityAverage(this.samples) {
    list = Float64List(samples);
  }

  final int samples;

  late Float64List list;
  int pos = 0;

  void add(double val) {
    pos++;
    if (pos >= samples) pos = 0;
    list[pos] = val.clamp(-1, 1);
  }

  double average() {
    var ret = 0.0;
    for (final v in list) {
      ret += v;
    }
    return ret / samples;
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key, this.onScrolling});

  final void Function(double scrollingVelocity)? onScrolling;

  @override
  Widget build(BuildContext context) {
    final velocity = VelocityAverage(20);
    var lastTime = DateTime.now();

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            velocity.add(
              (notification.scrollDelta ?? 0) /
                  (DateTime.now().millisecondsSinceEpoch -
                      lastTime.millisecondsSinceEpoch),
            );

            lastTime = DateTime.now();
            onScrolling?.call(velocity.average().abs());
          }
          if (notification is ScrollEndNotification) {
            onScrolling?.call(0);
          }
          return true;
        },
        child: ListView.builder(
          itemCount: 60,
          itemBuilder: (context, index) {
            return const CardEntry();
          },
        ),
      ),
    );
  }
}

class CardEntry extends StatelessWidget {
  const CardEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.account_circle, size: 42),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Widget 1',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Text('shader_preset'),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                print('Widget 1');
              },
              child: const Text('Widget 1'),
            ),
            const Icon(Icons.add_box_rounded, size: 42),
          ],
        ),
      ),
    );
  }
}
