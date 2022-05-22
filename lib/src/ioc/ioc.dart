part of core;

class Service {
  static Symbol http = Symbol('Mineral/Core/Http');
  static Symbol client = Symbol('Mineral/Core/Client');
  static Symbol environment = Symbol('Mineral/Core/Environment');
  static Symbol event = Symbol('Mineral/Core/Event');
}

IocContainer ioc = IocContainer.init();
