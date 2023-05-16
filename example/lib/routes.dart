import 'package:example/counter/data/counter_store.dart';
import 'package:example/counter/presentation/counter_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Routes {
  final _router = GoRouter(
    initialLocation: CounterScreen.routeName,
    routes: [
      GoRoute(
        path: CounterScreen.routeName,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: ChangeNotifierProvider(
              create: (context) => CounterStore(),
              builder: (context, child) => const CounterScreen(),
            ),
          );
        },
      ),
    ],
  );

  RouterConfig<Object>? get config => _router;
}
