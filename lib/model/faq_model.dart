import 'dart:convert';

class FaqModel {
  String? id;
  int? faqNo;

  String? question;
  String? answer;
  FaqModel({
    this.id,
    this.faqNo,
    this.question,
    this.answer,
  });

  FaqModel copyWith({
    String? id,
    int? faqNo,
    String? question,
    String? answer,
  }) {
    return FaqModel(
      id: id ?? this.id,
      faqNo: faqNo ?? this.faqNo,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'faqNo': faqNo,
      'question': question,
      'answer': answer,
    };
  }

  factory FaqModel.fromMap(Map<String, dynamic> map) {
    return FaqModel(
      id: map['id'],
      faqNo: map['faqNo']?.toInt(),
      question: map['question'],
      answer: map['answer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqModel.fromJson(String source) =>
      FaqModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FaqModel(id: $id, faqNo: $faqNo, question: $question, answer: $answer)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FaqModel &&
        other.id == id &&
        other.faqNo == faqNo &&
        other.question == question &&
        other.answer == answer;
  }

  @override
  int get hashCode {
    return id.hashCode ^ faqNo.hashCode ^ question.hashCode ^ answer.hashCode;
  }
}
