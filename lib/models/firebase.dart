// To parse this JSON data, do
//
//     final firebase = firebaseFromJson(jsonString);

import 'dart:convert';

Firebase firebaseFromJson(String str) => Firebase.fromJson(json.decode(str));

String firebaseToJson(Firebase data) => json.encode(data.toJson());

class Firebase {
  Competition? competition;
  String name;
  int order;
  bool show;
  Trainings? trainings;

  Firebase({
    required this.competition,
    required this.name,
    required this.order,
    required this.show,
    required this.trainings,
  });

  factory Firebase.fromMap(Map<dynamic, dynamic> map) {
    print(map.entries.first);
    return Firebase(
      competition: null,
      trainings: null,
      name: map["name"],
      order: map["order"],
      show: map["show"],
    );
  }

  factory Firebase.fromJson(Map<String, dynamic> json) => Firebase(
        competition: Competition.fromJson(json["competition"]),
        name: json["name"],
        order: json["order"],
        show: json["show"],
        trainings: Trainings.fromJson(json["trainings"]),
      );

  Map<String, dynamic> toJson() => {
        "competition": null,
        "name": name,
        "order": order,
        "show": show,
        "trainings": null,
      };
}

class Competition {
  O2Pet o2PetPf52LvFt8HcE;

  Competition({
    required this.o2PetPf52LvFt8HcE,
  });

  factory Competition.fromJson(Map<String, dynamic> json) => Competition(
        o2PetPf52LvFt8HcE: O2Pet.fromJson(json["-O2-petPf52LvFt8Hc-e"]),
      );

  Map<String, dynamic> toJson() => {
        "-O2-petPf52LvFt8Hc-e": o2PetPf52LvFt8HcE.toJson(),
      };
}

class O2Pet {
  String comment;
  DateTime date;
  String image;
  String kind;
  String place;
  int shotCount;
  int? indicator;

  O2Pet({
    required this.comment,
    required this.date,
    required this.image,
    required this.kind,
    required this.place,
    required this.shotCount,
    this.indicator,
  });

  factory O2Pet.fromJson(Map<String, dynamic> json) => O2Pet(
        comment: json["comment"],
        date: DateTime.parse(json["date"]),
        image: json["image"],
        kind: json["kind"],
        place: json["place"],
        shotCount: json["shotCount"],
        indicator: json["indicator"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "date": date.toIso8601String(),
        "image": image,
        "kind": kind,
        "place": place,
        "shotCount": shotCount,
        "indicator": indicator,
      };
}

class Trainings {
  O2Pet o2PetNwrFv7TjG1XgT;

  Trainings({
    required this.o2PetNwrFv7TjG1XgT,
  });

  factory Trainings.fromJson(Map<String, dynamic> json) => Trainings(
        o2PetNwrFv7TjG1XgT: O2Pet.fromJson(json["-O2-petNwrFV7TjG1XgT"]),
      );

  Map<String, dynamic> toJson() => {
        "-O2-petNwrFV7TjG1XgT": o2PetNwrFv7TjG1XgT.toJson(),
      };
}
