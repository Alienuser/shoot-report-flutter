class Training {
  final int? id;
  DateTime date;
  String image;
  int indicator;
  String place;
  String kind;
  int shotCount;
  List shots;
  String comment;
  final int weaponId;

  // Firebase key for deletion
  String? firebaseKey;

  Training(this.id, this.date, this.image, this.indicator, this.place,
      this.kind, this.shotCount, this.shots, this.comment, this.weaponId);
}
