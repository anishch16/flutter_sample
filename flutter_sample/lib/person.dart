// person.dart
class Person {
  late String name;
  late int age;
  late String bloodGroup;
  late String nationality;

  Person({
    required this.name,
    required this.age,
    required this.bloodGroup,
    required this.nationality,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'bloodGroup': bloodGroup,
      'nationality': nationality,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      bloodGroup: map['bloodGroup'] ?? '',
      nationality: map['nationality'] ?? '',
    );
  }
}
