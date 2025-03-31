
enum PageIndex{
  HOME(0), POST_LIST(1),MY_POST(2),MY_CHAT(3),MY_PAGE(4);

  final int page;

  const PageIndex(this.page);

  int get value => page;

}