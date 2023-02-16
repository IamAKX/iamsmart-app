import 'dart:convert';

class FaqModel {
  String? id;
  String? question;
  String? answer;
  FaqModel({
    this.id,
    this.question,
    this.answer,
  });

  FaqModel copyWith({
    String? id,
    String? question,
    String? answer,
  }) {
    return FaqModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }

  factory FaqModel.fromMap(Map<String, dynamic> map) {
    return FaqModel(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqModel.fromJson(String source) =>
      FaqModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FaqModel(id: $id, question: $question, answer: $answer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FaqModel &&
        other.id == id &&
        other.question == question &&
        other.answer == answer;
  }

  @override
  int get hashCode => id.hashCode ^ question.hashCode ^ answer.hashCode;
}
