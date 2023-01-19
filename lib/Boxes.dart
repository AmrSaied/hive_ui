import 'dart:io';
import 'dart:math' as math;

import 'customer.dart';

import 'package:hive_flutter/adapters.dart';

class Boxes {
  static Box<Customer> get customersBox => Hive.box<Customer>("customers");

  static Future<void> initHive() async {
    await Hive.initFlutter();
    openBoxes();
  }

  static Future<void> openBoxes() async {
    Hive.registerAdapter(CustomerAdapter());
    await Hive.openBox<Customer>("customers");
    _generateCustomer(customersBox);

  }

  static Map<Box<dynamic>, dynamic Function(dynamic json)> get allBoxes => {
        customersBox: (json) => Customer.fromJson(json),
      };

  static Future<void> _generateCustomer(Box<Customer> box) async {
    final numberValueExample = math.Random().nextInt(25545454).toString();;
    final id = math.Random().nextDouble().toString();
    final name = 'Customer$numberValueExample';
    final customer = Customer(
      id: id,
      name: name,
      numberValueExample: numberValueExample,
      phoneNumber: numberValueExample.toString(),
    );
    await box.put(customer.id, customer);
  }
}
