class Competition {
  final int? id;
  DateTime date;
  String image;
  String place;
  String kind;
  int shotCount;
  List shots;
  String comment;
  final int weaponId;

  // Firebase key for deletion/update
  String? firebaseKey;

  Competition(this.id, this.date, this.image, this.place, this.kind,
      this.shotCount, this.shots, this.comment, this.weaponId);
}
