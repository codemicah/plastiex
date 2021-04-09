class Ranking {
  String name, uid, avatar;
  int totalSubmissions, position;

  Ranking(
      {this.name = "No Name",
      this.uid,
      this.totalSubmissions,
      this.avatar = 'assets/imgs/avatar.jpg',
      this.position = 0});
}
