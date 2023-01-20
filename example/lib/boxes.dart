import 'dart:math' as math;

import 'package:hive_flutter/hive_flutter.dart';

import 'models/customer/customer.dart';
import 'models/organization/organization.dart';

class Boxes {
  static Box<Customer> get customersBox => Hive.box<Customer>("customer");

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await openBoxes();
  }

  static Future<void> openBoxes() async {
    Hive.registerAdapter(CustomerAdapter());
    Hive.registerAdapter(OrganizationAdapter());
    await Hive.openBox<Customer>("customer");
    await _generateCustomer(customersBox);
  }

  static Map<Box<dynamic>, dynamic Function(dynamic json)> get allBoxes => {
        customersBox: (json) => Customer.fromJson(json),
      };

  static Future<void> _generateCustomer(Box<Customer> box) async {
    final numberValueExample = math.Random().nextInt(25545454).toString();
    final id = math.Random().nextDouble().toString();
    final name = 'Customer$numberValueExample';
    final organization = Organization(
      id: id,
      name: "org$name",
      jobTitle: "org job for $name",
    );
    final customer = Customer(
      id: id,
      name: name,
      numberValueExample: numberValueExample,
      phoneNumber: numberValueExample.toString(),
      organization: organization,
    );
    await box.put(customer.id, customer);
  }
}
