class UserUpdate {
  final String name;

  UserUpdate({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

}