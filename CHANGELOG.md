## 1.0.1+2

* Fix: Listener mismatch when `widget.id` is a `JuneState` instance — the listener is now registered directly on that instance via `idState.addListenerId(widget.id, filter)`. Previously it was always registered on `localController` (the June-managed singleton for the type), so `setState([this])` called on a different instance would search the wrong HashMap, find no updaters, and produce no rebuild.

## 1.0.1

* Fix: `JuneBuilder` now correctly forwards `_creator` as `init` to `Binder`, enabling `global: false` to work with externally-created `JuneState` instances (issue [#8](https://github.com/melodysdreamj/june/issues/8)). Previously, passing a pre-existing instance via the creator function with `global: false` would throw a `BindError` because `BindElement` had no reference to the user-provided instance.
* Fix: Silent listener mismatch when the same state type is registered multiple times (e.g. across navigation pushes), causing `setState()` to find no updaters and skip rebuilds entirely.

## 1.0.0

* Optimized memory usage efficiency
* Add HTTP instance example

Thanks to [allasca](https://github.com/allasca)

## 0.8.6

* Improve pub score
* Update License

Thanks to [curogom](https://github.com/curogom)
