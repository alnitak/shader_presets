// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  double turns = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => turns += 0.2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ColoredBox(
            color: Colors.grey[800]!,
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedRotation(
                    turns: turns,
                    duration: const Duration(seconds: 1),
                    onEnd: () => setState(() => turns += 0.2),
                    child: const FlutterLogo(
                      size: 250,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'A package which implements'
                    '\nsome ready to use shaders, like'
                    '\ntransitions from gl-transitions.com '
                    '\nor ShaderToy.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Go Back'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
