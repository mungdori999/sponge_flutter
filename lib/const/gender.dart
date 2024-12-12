enum Gender {
  MALE(1, "남자"),
  NEUTERED_MALE(2, "남자 (중)"),
  FEMALE(3, "여자"),
  NEUTERED_FEMALE(4, "여자 (중)");

  final int code;
  final String description;

  const Gender(this.code, this.description);

  static String getDescriptionByCode(int code) {
    return Gender.values
        .firstWhere((category) => category.code == code,
        orElse: () => Gender.MALE)
        .description;
  }

  static int getCodeByDescription(String description) {
    return Gender.values
        .firstWhere(
            (category) => category.description == description,
        orElse: () => Gender.MALE)
        .code;
  }
}
