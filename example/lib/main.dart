import 'package:example/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(routes: Routes()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.routes});
  final Routes routes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: routes.config,
    );
  }
}
