// ignore: one_member_abstracts

// ignore: one_member_abstracts
abstract class ConnectionsInterface<T> {
  T dependencies();
}

/// [Connections] should be extended or implemented.
/// When using `JuneMaterialApp`, all `JunePage`s and navigation
/// methods (like June.to()) have a `binding` property that takes an
/// instance of Connections to manage the
/// dependencies() (via June.put()) for the Route you are opening.
// ignore: one_member_abstracts
@Deprecated('Use Binding instead')
abstract class Connections extends ConnectionsInterface<void> {
  @override
  void dependencies();
}

// /// Simplifies Connections generation from a single callback.
// /// To avoid the creation of a custom Binding instance per route.
// ///
// /// Example:
// /// ```
// /// JunePage(
// ///   name: '/',
// ///   page: () => Home(),
// ///   // This might cause you an error.
// ///   // binding: ConnectionsBuilder(() => June.put(HomeController())),
// ///   binding: ConnectionsBuilder(() { June.put(HomeController(); })),
// ///   // Using .lazyPut() works fine.
// ///   // binding: ConnectionsBuilder(() => June.lazyPut(() => HomeController())),
// /// ),
// /// ```
// class ConnectionsBuilder<T> extends Connections {
//   /// Register your dependencies in the [builder] callback.
//   final AdapterCallback builder;

//   /// Shortcut to register 1 Controller with June.put(),
//   /// Prevents the issue of the fat arrow function with the constructor.
//   /// ConnectionsBuilder(() => June.put(HomeController())),
//   ///
//   /// Sample:
//   /// ```
//   /// JunePage(
//   ///   name: '/',
//   ///   page: () => Home(),
//   ///   binding: ConnectionsBuilder.put(() => HomeController()),
//   /// ),
//   /// ```
//   factory ConnectionsBuilder.put(BuilderPattern<T> builder,
//       {String? tag, bool permanent = false}) {
//     return ConnectionsBuilder(
//         () => June.put<T>(builder(), tag: tag, permanent: permanent));
//   }

//   /// WARNING: don't use `()=> June.put(Controller())`,
//   /// if only passing 1 callback use `ConnectionsBuilder.put(Controller())`
//   /// or `ConnectionsBuilder(()=> June.lazyPut(Controller()))`
//   ConnectionsBuilder(this.builder);

//   @override
//   void dependencies() {
//     builder();
//   }
// }

typedef AdapterCallback = void Function();
