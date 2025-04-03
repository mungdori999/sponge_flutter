class PetCreate {
  String name;
  String breed;
  int gender;
  int age;
  double weight;
  String petImgUrl;

  PetCreate(
      {this.name = '',
      this.breed = '',
      this.gender = 1,
      this.age = 0,
      this.weight = 0,
      this.petImgUrl = ''});

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
