class Pet {
  final int id;
  final String name;
  final String breed;
  final int gender;
  final int age;
  final double weight;
  final String petImgUrl;

  Pet(
      {required this.id,
      required this.name,
      required this.breed,
      required this.gender,
      required this.age,
      required this.weight,
      required this.petImgUrl});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      gender: json['gender'],
      age: json['age'],
      weight: json['weight'],
      petImgUrl: json['petImgUrl'],
    );
  }
}
