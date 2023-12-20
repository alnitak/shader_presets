// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return const CardEntry();
        },
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
        padding: const EdgeInsets.all(16),
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
