import 'dart:convert';

class TransactionActivityModel {
  String? comment;
  DateTime? createdAt;
  TransactionActivityModel({
    this.comment,
    this.createdAt,
  });

  TransactionActivityModel copyWith({
    String? comment,
    DateTime? createdAt,
  }) {
    return TransactionActivityModel(
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory TransactionActivityModel.fromMap(Map<String, dynamic> map) {
    return TransactionActivityModel(
      comment: map['comment'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionActivityModel.fromJson(String source) =>
      TransactionActivityModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'TransactionActivityModel(comment: $comment, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionActivityModel &&
        other.comment == comment &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => comment.hashCode ^ createdAt.hashCode;
}
