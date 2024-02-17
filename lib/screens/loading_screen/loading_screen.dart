import 'package:flutter/material.dart';

import '../../widgets/LoadingCircle/loading_circle.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingCircle(),
      ),
    );
  }
}
