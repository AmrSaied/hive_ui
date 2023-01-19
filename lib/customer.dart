import 'package:hive_flutter/adapters.dart';

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

  const Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.numberValueExample,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'numberValueExample': numberValueExample,
    };
  }

  factory Customer.fromJson(dynamic map) {
    return Customer(
      id: map['id'] as String,
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      numberValueExample: map['numberValueExample'] as String,
    );
  }
}
