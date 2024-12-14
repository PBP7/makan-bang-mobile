// To parse this JSON data, do
//
//     final forumReply = forumReplyFromJson(jsonString);

import 'dart:convert';

List<ForumReply> forumReplyFromJson(String str) => List<ForumReply>.from(json.decode(str).map((x) => ForumReply.fromJson(x)));

String forumReplyToJson(List<ForumReply> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForumReply {
    int id;
    String reply;
    DateTime createdAt;
    User user;
    Question question;

    ForumReply({
        required this.id,
        required this.reply,
        required this.createdAt,
        required this.user,
        required this.question,
    });

    factory ForumReply.fromJson(Map<String, dynamic> json) => ForumReply(
        id: json["id"],
        reply: json["reply"],
        createdAt: DateTime.parse(json["created_at"]),
        user: User.fromJson(json["user"]),
        question: Question.fromJson(json["question"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "reply": reply,
        "created_at": createdAt.toIso8601String(),
        "user": user.toJson(),
        "question": question.toJson(),
    };
}

class Question {
    int id;
    String title;

    Question({
        required this.id,
        required this.title,
    });

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}

class User {
    int id;
    String username;

    User({
        required this.id,
        required this.username,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
    };
}