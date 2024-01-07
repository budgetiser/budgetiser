import 'package:budgetiser/shared/dataClasses/selectable.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:flutter/material.dart';

class Account extends Selectable {
  int id;
  double balance;
  String? description;
  bool archived;

  Account({
    required super.name,
    required super.icon,
    required super.color,
    required this.id,
    required this.balance,
    this.archived = false,
    this.description,
  });

  Account.fromDBmap(Map<String, dynamic> map)
      : id = map['id'],
        description = map['description'],
        balance = map['balance'],
        archived = map['archived'] == 1,
        super(
          name: map['name'].toString(),
          color: Color(map['color']),
          icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
        );

  Map<String, dynamic> toMap() => {
        'name': name.trim(),
        'icon': icon.codePoint,
        'color': color.value,
        'balance': roundDouble(balance), // for json export
        'description': description?.trim(),
        'archived': archived ? 1 : 0,
      };

  Map<String, dynamic> toJsonMap() {
    var m = toMap();
    m['id'] = id;
    return m;
  }

  @override
  String toString() {
    return 'Account: ${toJsonMap()}';
  }

  @override
  bool operator ==(Object other) =>
      other is Account &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.name == name &&
      other.icon == icon &&
      other.color == color &&
      other.description == description &&
      other.archived == archived &&
      other.balance == balance;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        icon,
        color,
        description,
        archived,
        balance,
      );
}
