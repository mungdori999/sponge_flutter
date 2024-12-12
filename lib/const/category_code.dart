enum CategoryCode {
  all(0, "전체"),
  separation(100, "분리불안"),
  bowel(200, "배변"),
  bark(300, "짖음"),
  social(400, "사회성"),
  aggression(500, "공격성"),
  basic(600, "기본 교육");

  final int code;
  final String description;

  const CategoryCode(this.code, this.description);

  static String getDescriptionByCode(int code) {
    return CategoryCode.values
        .firstWhere((category) => category.code == code,
            orElse: () => CategoryCode.all)
        .description;
  }

  static int getCodeByDescription(String description) {
    return CategoryCode.values
        .firstWhere(
          (category) => category.description == description,
          orElse: () => CategoryCode.all)
        .code;
  }

  static Map<int,String> getAllDescription() {
    Map<int, String> categoryMap = {};
    CategoryCode.values.where((category) => category != CategoryCode.all).toList()
        .asMap()
        .forEach((index, category) {
      categoryMap[index] = category.description;
    });
    return categoryMap;
  }
}
