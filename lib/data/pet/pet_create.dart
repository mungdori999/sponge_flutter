class PetCreate {
  final String name;
  final String breed;
  final int gender;
  final int age;
  final double weight;
  final String petImgUrl;

  PetCreate(
      {required this.name,
      required this.breed,
      required this.gender,
      required this.age,
      required this.weight,
      required this.petImgUrl});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'breed': breed,
      'gender': gender,
      'age': age,
      'weight': weight,
      'petImgUrl': petImgUrl,
    };
  }
}
