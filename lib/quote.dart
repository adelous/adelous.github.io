class Quote {
  final String sentence;
  final String depresent;
  final String arverb;

  Quote({
    required this.sentence,
    required this.depresent,
    required this.arverb,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      sentence: json['sentence'],
      depresent: json['depresent'],
      arverb: json['arverb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'depresent': depresent,
      'arverb': arverb,
    };
  }
}
