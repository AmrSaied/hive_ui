import 'package:hive_flutter/adapters.dart';

import '../organization/organization.dart';

part 'customer.g.dart';

@HiveType(typeId: 1)
class Customer {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final String numberValueExample;
  @HiveField(4)
  final Organization organization;

  const Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.numberValueExample,
    required this.organization,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'numberValueExample': numberValueExample,
      'organization': organization.toJson(),
    };
  }

  factory Customer.fromJson(dynamic map) {
    return Customer(
        id: map['id'] as String,
        name: map['name'] as String,
        phoneNumber: map['phoneNumber'] as String,
        numberValueExample: map['numberValueExample'] as String,
        organization: Organization.fromJson(map['organization']));
  }
}
