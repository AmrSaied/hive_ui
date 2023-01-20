import 'package:hive_flutter/adapters.dart';

part 'organization.g.dart';

@HiveType(typeId: 2)
class Organization {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String jobTitle;

  Organization({
    required this.id,
    required this.name,
    required this.jobTitle,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "jobTitle": jobTitle,
      };
  factory Organization.fromJson(dynamic json) => Organization(
        id: json['id'],
        name: json['name'],
        jobTitle: json['jobTitle'],
      );
}
