import 'dart:convert';
/// _id : "693257cff063430a6e61f7f2"
/// name : "Ace of Wands"
/// arcana : "Minor Arcana"
/// suit : "Wands"
/// number_or_rank : "Ace"
/// image_url : "https://drive.usercontent.google.com/download?id=1AGIctmWo8qx96Ui5eZUToyqk-BtdYUfQ&export=view&authuser=0"
/// short_description : "New beginnings, inspiration, creative spark, potential, enthusiasm."
/// core_meanings : {"meaning_upright":"New beginnings, inspiration, creative spark, potential, enthusiasm.","meaning_reversed":"Lack of direction, delays, creative blocks, missed opportunities."}
/// love : {"love_upright":"New romantic spark, passionate beginning, sexual chemistry.","love_reversed":"Lack of passion, creative blocks in relationship."}
/// career : {"career_upright":"New job, promotion, creative project, business startup.","career_reversed":"Career delays, lack of motivation, blocked creativity."}
/// finance : {"finance_upright":"New financial opportunity, investment potential.","finance_reversed":"Financial delays, poor investment timing."}
/// advice : {"advice_upright":"Seize the creative spark; start that new venture now.","advice_reversed":"Clear creative blocks; find your passion again."}
/// yes_no_answer : "Yes"
/// main_energy : "Creative potential"
/// keywords : ["inspiration","new_beginnings","creativity","potential","enthusiasm"]
/// element : "Fire"
/// planet_or_zodiac : "Fire element pure"
/// tags : ["minor_arcana","wands","creation","inspiration","beginnings"]
/// display_order : 1
/// createdAt : "2025-12-05T03:55:59.787Z"
/// updatedAt : "2025-12-05T03:55:59.787Z"

TarotCardEntity tarotCardEntityFromJson(String str) => TarotCardEntity.fromJson(json.decode(str));
String tarotCardEntityToJson(TarotCardEntity data) => json.encode(data.toJson());
class TarotCardEntity {
  TarotCardEntity({
      String? id, 
      String? name, 
      String? arcana, 
      String? suit, 
      dynamic numberOrRank,
      String? imageUrl, 
      String? shortDescription, 
      CoreMeanings? coreMeanings, 
      Love? love, 
      Career? career, 
      Finance? finance, 
      Advice? advice, 
      String? yesNoAnswer, 
      String? mainEnergy, 
      List<String>? keywords, 
      String? element, 
      String? planetOrZodiac, 
      List<String>? tags, 
      num? displayOrder, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _arcana = arcana;
    _suit = suit;
    _numberOrRank = numberOrRank;
    _imageUrl = imageUrl;
    _shortDescription = shortDescription;
    _coreMeanings = coreMeanings;
    _love = love;
    _career = career;
    _finance = finance;
    _advice = advice;
    _yesNoAnswer = yesNoAnswer;
    _mainEnergy = mainEnergy;
    _keywords = keywords;
    _element = element;
    _planetOrZodiac = planetOrZodiac;
    _tags = tags;
    _displayOrder = displayOrder;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TarotCardEntity.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _arcana = json['arcana'];
    _suit = json['suit'];
    _numberOrRank = json['number_or_rank'];
    _imageUrl = json['image_url'];
    _shortDescription = json['short_description'];
    _coreMeanings = json['core_meanings'] != null ? CoreMeanings.fromJson(json['core_meanings']) : null;
    _love = json['love'] != null ? Love.fromJson(json['love']) : null;
    _career = json['career'] != null ? Career.fromJson(json['career']) : null;
    _finance = json['finance'] != null ? Finance.fromJson(json['finance']) : null;
    _advice = json['advice'] != null ? Advice.fromJson(json['advice']) : null;
    _yesNoAnswer = json['yes_no_answer'];
    _mainEnergy = json['main_energy'];
    _keywords = json['keywords'] != null ? json['keywords'].cast<String>() : [];
    _element = json['element'];
    _planetOrZodiac = json['planet_or_zodiac'];
    _tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    _displayOrder = json['display_order'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _name;
  String? _arcana;
  String? _suit;
  dynamic _numberOrRank;
  String? _imageUrl;
  String? _shortDescription;
  CoreMeanings? _coreMeanings;
  Love? _love;
  Career? _career;
  Finance? _finance;
  Advice? _advice;
  String? _yesNoAnswer;
  String? _mainEnergy;
  List<String>? _keywords;
  String? _element;
  String? _planetOrZodiac;
  List<String>? _tags;
  num? _displayOrder;
  String? _createdAt;
  String? _updatedAt;
TarotCardEntity copyWith({  String? id,
  String? name,
  String? arcana,
  String? suit,
  dynamic numberOrRank,
  String? imageUrl,
  String? shortDescription,
  CoreMeanings? coreMeanings,
  Love? love,
  Career? career,
  Finance? finance,
  Advice? advice,
  String? yesNoAnswer,
  String? mainEnergy,
  List<String>? keywords,
  String? element,
  String? planetOrZodiac,
  List<String>? tags,
  num? displayOrder,
  String? createdAt,
  String? updatedAt,
}) => TarotCardEntity(  id: id ?? _id,
  name: name ?? _name,
  arcana: arcana ?? _arcana,
  suit: suit ?? _suit,
  numberOrRank: numberOrRank ?? _numberOrRank,
  imageUrl: imageUrl ?? _imageUrl,
  shortDescription: shortDescription ?? _shortDescription,
  coreMeanings: coreMeanings ?? _coreMeanings,
  love: love ?? _love,
  career: career ?? _career,
  finance: finance ?? _finance,
  advice: advice ?? _advice,
  yesNoAnswer: yesNoAnswer ?? _yesNoAnswer,
  mainEnergy: mainEnergy ?? _mainEnergy,
  keywords: keywords ?? _keywords,
  element: element ?? _element,
  planetOrZodiac: planetOrZodiac ?? _planetOrZodiac,
  tags: tags ?? _tags,
  displayOrder: displayOrder ?? _displayOrder,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get name => _name;
  String? get arcana => _arcana;
  String? get suit => _suit;
  dynamic? get numberOrRank => _numberOrRank;
  String? get imageUrl => _imageUrl;
  String? get shortDescription => _shortDescription;
  CoreMeanings? get coreMeanings => _coreMeanings;
  Love? get love => _love;
  Career? get career => _career;
  Finance? get finance => _finance;
  Advice? get advice => _advice;
  String? get yesNoAnswer => _yesNoAnswer;
  String? get mainEnergy => _mainEnergy;
  List<String>? get keywords => _keywords;
  String? get element => _element;
  String? get planetOrZodiac => _planetOrZodiac;
  List<String>? get tags => _tags;
  num? get displayOrder => _displayOrder;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['arcana'] = _arcana;
    map['suit'] = _suit;
    map['number_or_rank'] = _numberOrRank;
    map['image_url'] = _imageUrl;
    map['short_description'] = _shortDescription;
    if (_coreMeanings != null) {
      map['core_meanings'] = _coreMeanings?.toJson();
    }
    if (_love != null) {
      map['love'] = _love?.toJson();
    }
    if (_career != null) {
      map['career'] = _career?.toJson();
    }
    if (_finance != null) {
      map['finance'] = _finance?.toJson();
    }
    if (_advice != null) {
      map['advice'] = _advice?.toJson();
    }
    map['yes_no_answer'] = _yesNoAnswer;
    map['main_energy'] = _mainEnergy;
    map['keywords'] = _keywords;
    map['element'] = _element;
    map['planet_or_zodiac'] = _planetOrZodiac;
    map['tags'] = _tags;
    map['display_order'] = _displayOrder;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}

/// advice_upright : "Seize the creative spark; start that new venture now."
/// advice_reversed : "Clear creative blocks; find your passion again."

Advice adviceFromJson(String str) => Advice.fromJson(json.decode(str));
String adviceToJson(Advice data) => json.encode(data.toJson());
class Advice {
  Advice({
      String? adviceUpright, 
      String? adviceReversed,}){
    _adviceUpright = adviceUpright;
    _adviceReversed = adviceReversed;
}

  Advice.fromJson(dynamic json) {
    _adviceUpright = json['advice_upright'];
    _adviceReversed = json['advice_reversed'];
  }
  String? _adviceUpright;
  String? _adviceReversed;
Advice copyWith({  String? adviceUpright,
  String? adviceReversed,
}) => Advice(  adviceUpright: adviceUpright ?? _adviceUpright,
  adviceReversed: adviceReversed ?? _adviceReversed,
);
  String? get adviceUpright => _adviceUpright;
  String? get adviceReversed => _adviceReversed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['advice_upright'] = _adviceUpright;
    map['advice_reversed'] = _adviceReversed;
    return map;
  }

}

/// finance_upright : "New financial opportunity, investment potential."
/// finance_reversed : "Financial delays, poor investment timing."

Finance financeFromJson(String str) => Finance.fromJson(json.decode(str));
String financeToJson(Finance data) => json.encode(data.toJson());
class Finance {
  Finance({
      String? financeUpright, 
      String? financeReversed,}){
    _financeUpright = financeUpright;
    _financeReversed = financeReversed;
}

  Finance.fromJson(dynamic json) {
    _financeUpright = json['finance_upright'];
    _financeReversed = json['finance_reversed'];
  }
  String? _financeUpright;
  String? _financeReversed;
Finance copyWith({  String? financeUpright,
  String? financeReversed,
}) => Finance(  financeUpright: financeUpright ?? _financeUpright,
  financeReversed: financeReversed ?? _financeReversed,
);
  String? get financeUpright => _financeUpright;
  String? get financeReversed => _financeReversed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['finance_upright'] = _financeUpright;
    map['finance_reversed'] = _financeReversed;
    return map;
  }

}

/// career_upright : "New job, promotion, creative project, business startup."
/// career_reversed : "Career delays, lack of motivation, blocked creativity."

Career careerFromJson(String str) => Career.fromJson(json.decode(str));
String careerToJson(Career data) => json.encode(data.toJson());
class Career {
  Career({
      String? careerUpright, 
      String? careerReversed,}){
    _careerUpright = careerUpright;
    _careerReversed = careerReversed;
}

  Career.fromJson(dynamic json) {
    _careerUpright = json['career_upright'];
    _careerReversed = json['career_reversed'];
  }
  String? _careerUpright;
  String? _careerReversed;
Career copyWith({  String? careerUpright,
  String? careerReversed,
}) => Career(  careerUpright: careerUpright ?? _careerUpright,
  careerReversed: careerReversed ?? _careerReversed,
);
  String? get careerUpright => _careerUpright;
  String? get careerReversed => _careerReversed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['career_upright'] = _careerUpright;
    map['career_reversed'] = _careerReversed;
    return map;
  }

}

/// love_upright : "New romantic spark, passionate beginning, sexual chemistry."
/// love_reversed : "Lack of passion, creative blocks in relationship."

Love loveFromJson(String str) => Love.fromJson(json.decode(str));
String loveToJson(Love data) => json.encode(data.toJson());
class Love {
  Love({
      String? loveUpright, 
      String? loveReversed,}){
    _loveUpright = loveUpright;
    _loveReversed = loveReversed;
}

  Love.fromJson(dynamic json) {
    _loveUpright = json['love_upright'];
    _loveReversed = json['love_reversed'];
  }
  String? _loveUpright;
  String? _loveReversed;
Love copyWith({  String? loveUpright,
  String? loveReversed,
}) => Love(  loveUpright: loveUpright ?? _loveUpright,
  loveReversed: loveReversed ?? _loveReversed,
);
  String? get loveUpright => _loveUpright;
  String? get loveReversed => _loveReversed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['love_upright'] = _loveUpright;
    map['love_reversed'] = _loveReversed;
    return map;
  }

}

/// meaning_upright : "New beginnings, inspiration, creative spark, potential, enthusiasm."
/// meaning_reversed : "Lack of direction, delays, creative blocks, missed opportunities."

CoreMeanings coreMeaningsFromJson(String str) => CoreMeanings.fromJson(json.decode(str));
String coreMeaningsToJson(CoreMeanings data) => json.encode(data.toJson());
class CoreMeanings {
  CoreMeanings({
      String? meaningUpright, 
      String? meaningReversed,}){
    _meaningUpright = meaningUpright;
    _meaningReversed = meaningReversed;
}

  CoreMeanings.fromJson(dynamic json) {
    _meaningUpright = json['meaning_upright'];
    _meaningReversed = json['meaning_reversed'];
  }
  String? _meaningUpright;
  String? _meaningReversed;
CoreMeanings copyWith({  String? meaningUpright,
  String? meaningReversed,
}) => CoreMeanings(  meaningUpright: meaningUpright ?? _meaningUpright,
  meaningReversed: meaningReversed ?? _meaningReversed,
);
  String? get meaningUpright => _meaningUpright;
  String? get meaningReversed => _meaningReversed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['meaning_upright'] = _meaningUpright;
    map['meaning_reversed'] = _meaningReversed;
    return map;
  }

}