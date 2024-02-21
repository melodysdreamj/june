/// JuneX by default disposes unused controllers from memory,
/// Through different behaviors.
/// IntelligentManagement.full
/// [IntelligentManagement.full] is the default one. Dispose classes that are
/// not being used and were not set to be permanent. In the majority
/// of the cases you will want to keep this config untouched.
/// If you new to JuneX then don't change this.
/// [IntelligentManagement.onlyBuilder] only controllers started in init:
/// or loaded into a Binding with June.lazyPut() will be disposed. If you use
/// June.put() or June.putAsync() or any other approach, IntelligentManagement
/// will not have permissions to exclude this dependency. With the default
/// behavior, even widgets instantiated with "June.put" will be removed,
/// unlike IntelligentManagement.onlyBuilders.
/// [IntelligentManagement.keepFactory]Just like IntelligentManagement.full,
/// it will remove it's dependencies when it's not being used anymore.
/// However, it will keep their factory, which means it will recreate
/// the dependency if you need that instance again.
enum IntelligentManagement {
  full,
  onlyBuilder,
  keepFactory,
}
