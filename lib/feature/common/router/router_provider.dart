import 'package:flutter/material.dart';
import 'package:flutter_name_card_printer/feature/home/screen/home_screen.dart';
import 'package:flutter_name_card_printer/feature/input/screen/input_screen.dart';
import 'package:flutter_name_card_printer/feature/setting/screen/setting_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) => GoRouter(
      routes: $appRoutes,
    );

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@TypedGoRoute<InputRoute>(path: '/input')
class InputRoute extends GoRouteData {
  const InputRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const InputScreen();
}

@TypedGoRoute<SettingRoute>(path: '/setting')
class SettingRoute extends GoRouteData {
  const SettingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingScreen();
}
