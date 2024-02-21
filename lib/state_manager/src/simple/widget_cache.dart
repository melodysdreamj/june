import 'package:flutter/widgets.dart';

abstract class JuneWidgetCache extends Widget {
  const JuneWidgetCache({Key? key}) : super(key: key);

  @override
  JuneWidgetCacheElement createElement() => JuneWidgetCacheElement(this);

  @protected
  @factory
  WidgetCache createWidgetCache();
}

class JuneWidgetCacheElement extends ComponentElement {
  JuneWidgetCacheElement(JuneWidgetCache widget)
      : cache = widget.createWidgetCache(),
        super(widget) {
    cache._element = this;
    cache._widget = widget;
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    cache.onInit();
    super.mount(parent, newSlot);
  }

  @override
  Widget build() => cache.build(this);

  final WidgetCache<JuneWidgetCache> cache;

  @override
  void activate() {
    super.activate();
    markNeedsBuild();
  }

  @override
  void unmount() {
    super.unmount();
    cache.onClose();
    cache._element = null;
  }
}

@optionalTypeArgs
abstract class WidgetCache<T extends JuneWidgetCache> {
  T? get widget => _widget;
  T? _widget;

  BuildContext? get context => _element;

  JuneWidgetCacheElement? _element;

  @protected
  @mustCallSuper
  void onInit() {}

  @protected
  @mustCallSuper
  void onClose() {}

  @protected
  Widget build(BuildContext context);
}
