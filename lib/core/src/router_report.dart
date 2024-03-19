import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:june/core/src/smart_management.dart';
import 'package:june/instance/june_instance.dart';

import 'june_main.dart';

class RouterReportManager<T> {
  /// Holds a reference to `June.reference` when the Instance was
  /// created to manage the memory.
  final Map<T?, List<String>> _routesKey = {};

  /// Stores the onClose() references of instances created with `June.create()`
  /// using the `June.reference`.
  /// Experimental feature to keep the lifecycle and memory management with
  /// non-singleton instances.
  final Map<T?, HashSet<Function>> _routesByCreate = {};

  static RouterReportManager? _instance;

  RouterReportManager._();

  static RouterReportManager get instance =>
      _instance ??= RouterReportManager._();

  static void dispose() {
    _instance = null;
  }

  void printInstanceStack() {
    debugPrint(_routesKey.toString());
  }

  T? _current;

  // ignore: use_setters_to_change_properties
  void reportCurrentRoute(T newRoute) {
    _current = newRoute;
  }

  /// Links a Class instance [S] (or [tag]) to the current route.
  /// Requires usage of `JuneMaterialApp`.
  void reportDependencyLinkedToRoute(String dependencyKey) {
    if (_current == null) return;
    if (_routesKey.containsKey(_current)) {
      _routesKey[_current!]!.add(dependencyKey);
    } else {
      _routesKey[_current] = <String>[dependencyKey];
    }
  }

  void clearRouteKeys() {
    _routesKey.clear();
    _routesByCreate.clear();
  }

  void appendRouteByCreate(JuneLifeCycleMixin i) {
    _routesByCreate[_current] ??= HashSet<Function>();
    // _routesByCreate[June.reference]!.add(i.onDelete as Function);
    _routesByCreate[_current]!.add(i.onDelete);
  }

  void reportRouteDispose(T disposed) {
    if (June.intelligentManagement != IntelligentManagement.onlyBuilder) {
      // obscure(Engine.instance)!.addPostFrameCallback((_) {
      // Future.microtask(() {
      _removeDependencyByRoute(disposed);
      // });
    }
  }

  void reportRouteWillDispose(T disposed) {
    final keysToRemove = <String>[];

    _routesKey[disposed]?.forEach(keysToRemove.add);

    /// Removes `June.create()` instances registered in `routeName`.
    if (_routesByCreate.containsKey(disposed)) {
      for (final onClose in _routesByCreate[disposed]!) {
        // assure the [DisposableInterface] instance holding a reference
        // to onClose() wasn't disposed.
        onClose();
      }
      _routesByCreate[disposed]!.clear();
      _routesByCreate.remove(disposed);
    }

    for (final element in keysToRemove) {
      June.markAsDirty(key: element);

      //_routesKey.remove(element);
    }

    keysToRemove.clear();
  }

  /// Clears from memory registered Instances associated with [routeName] when
  /// using `June.intelligentManagement` as [IntelligentManagement.full] or
  /// [IntelligentManagement.keepFactory]
  /// Meant for internal usage of `JunePageRoute` and `JuneDialogRoute`
  void _removeDependencyByRoute(T routeName) {
    final keysToRemove = <String>[];

    _routesKey[routeName]?.forEach(keysToRemove.add);

    /// Removes `June.create()` instances registered in `routeName`.
    if (_routesByCreate.containsKey(routeName)) {
      for (final onClose in _routesByCreate[routeName]!) {
        // assure the [DisposableInterface] instance holding a reference
        // to onClose() wasn't disposed.
        onClose();
      }
      _routesByCreate[routeName]!.clear();
      _routesByCreate.remove(routeName);
    }

    for (final element in keysToRemove) {
      final value = June.delete(key: element);
      if (value) {
        _routesKey[routeName]?.remove(element);
      }
    }

    keysToRemove.clear();
  }
}
