// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String? type;
  List<String>? query;
  List<Feature>? features;
  String? attribution;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    type: json["type"],
    query: List<String>.from(json["query"].map((x) => x)),
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    attribution: json["attribution"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "query": List<dynamic>.from(query!.map((x) => x)),
    "features": List<dynamic>.from(features!.map((x) => x.toJson())),
    "attribution": attribution,
  };
}

class Feature {
  Feature({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.textEs,
    this.languageEs,
    this.placeNameEs,
    this.text,
    this.language,
    this.placeName,
    this.center,
    this.geometry,
    this.context,
    this.matchingText,
    this.matchingPlaceName,
    this.bbox,
  });

  String? id;
  String? type;
  List<String>? placeType;
  double? relevance;
  Properties? properties;
  String? textEs;
  String? languageEs;
  String? placeNameEs;
  String? text;
  String? language;
  String? placeName;
  List<double>? center;
  Geometry? geometry;
  List<Context>? context;
  String? matchingText;
  String? matchingPlaceName;
  List<double>? bbox;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json["id"],
    type: json["type"],
    placeType: List<String>.from(json["place_type"].map((x) => x)),
    relevance: json["relevance"].toDouble(),
    properties: Properties.fromJson(json["properties"]),
    textEs: json["text_es"],
    languageEs: json["language_es"] == null ? null : json["language_es"],
    placeNameEs: json["place_name_es"],
    text: json["text"],
    language: json["language"] == null ? null : json["language"],
    placeName: json["place_name"],
    center: List<double>.from(json["center"].map((x) => x.toDouble())),
    geometry: Geometry.fromJson(json["geometry"]),
    context: List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
    matchingText: json["matching_text"] == null ? null : json["matching_text"],
    matchingPlaceName: json["matching_place_name"] == null ? null : json["matching_place_name"],
    bbox: json["bbox"] == null ? null : List<double>.from(json["bbox"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "place_type": List<dynamic>.from(placeType!.map((x) => x)),
    "relevance": relevance,
    "properties": properties!.toJson(),
    "text_es": textEs,
    "language_es": languageEs == null ? null : languageEs,
    "place_name_es": placeNameEs,
    "text": text,
    "language": language == null ? null : language,
    "place_name": placeName,
    "center": List<dynamic>.from(center!.map((x) => x)),
    "geometry": geometry!.toJson(),
    "context": List<dynamic>.from(context!.map((x) => x.toJson())),
    "matching_text": matchingText == null ? null : matchingText,
    "matching_place_name": matchingPlaceName == null ? null : matchingPlaceName,
    "bbox": bbox == null ? null : List<dynamic>.from(bbox!.map((x) => x)),
  };
}

class Context {
  Context({
    this.id,
    this.shortCode,
    this.wikidata,
    this.textEs,
    this.languageEs,
    this.text,
    this.language,
  });

  String? id;
  String? shortCode;
  String? wikidata;
  String? textEs;
  Language? languageEs;
  String? text;
  Language? language;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
    id: json["id"],
    shortCode: json["short_code"],
    wikidata: json["wikidata"],
    textEs: json["text_es"],
    languageEs: languageValues.map[json["language_es"]],
    text: json["text"],
    language: languageValues.map[json["language"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "short_code": shortCode,
    "wikidata": wikidata,
    "text_es": textEs,
    "language_es": languageValues.reverse[languageEs],
    "text": text,
    "language": languageValues.reverse[language],
  };
}

enum Language { ES }

final languageValues = EnumValues({
  "es": Language.ES
});

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String? type;
  List<double>? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class Properties {
  Properties({
    this.wikidata,
  });

  String? wikidata;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    wikidata: json["wikidata"] == null ? null : json["wikidata"],
  );

  Map<String, dynamic> toJson() => {
    "wikidata": wikidata == null ? null : wikidata,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
