import 'dart:convert';

class EmailModel {
  String? from;
  String? to;
  String? subject;
  String? text;
  EmailModel({
    this.from,
    this.to,
    this.subject,
    this.text,
  });

  EmailModel copyWith({
    String? from,
    String? to,
    String? subject,
    String? text,
  }) {
    return EmailModel(
      from: from ?? this.from,
      to: to ?? this.to,
      subject: subject ?? this.subject,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'subject': subject,
      'text': text,
    };
  }

  factory EmailModel.fromMap(Map<String, dynamic> map) {
    return EmailModel(
      from: map['from'],
      to: map['to'],
      subject: map['subject'],
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EmailModel.fromJson(String source) =>
      EmailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EmailModel(from: $from, to: $to, subject: $subject, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailModel &&
        other.from == from &&
        other.to == to &&
        other.subject == subject &&
        other.text == text;
  }

  @override
  int get hashCode {
    return from.hashCode ^ to.hashCode ^ subject.hashCode ^ text.hashCode;
  }
}
