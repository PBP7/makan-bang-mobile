// To parse this JSON data, do
//
//     final forumQuestion = forumQuestionFromJson(jsonString);

import 'dart:convert';

List<ForumQuestion> forumQuestionFromJson(String str) => List<ForumQuestion>.from(json.decode(str).map((x) => ForumQuestion.fromJson(x)));

String forumQuestionToJson(List<ForumQuestion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForumQuestion {
    int id;
    String title;
    String question;
    String topic;
    int replycount;
    DateTime createdAt;
    User user;
    List<Reply> replies;

    ForumQuestion({
        required this.id,
        required this.title,
        required this.question,
        required this.topic,
        required this.replycount,
        required this.createdAt,
        required this.user,
        required this.replies,
    });

    factory ForumQuestion.fromJson(Map<String, dynamic> json) => ForumQuestion(
        id: json["id"],
        title: json["title"],
        question: json["question"],
        topic: json["topic"],
        replycount: json["replycount"],
        createdAt: DateTime.parse(json["created_at"]),
        user: User.fromJson(json["user"]),
        replies: List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "question": question,
        "topic": topic,
        "replycount": replycount,
        "created_at": createdAt.toIso8601String(),
        "user": user.toJson(),
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
    };
}

class Reply {
    int id;
    String reply;
    DateTime createdAt;
    User user;

    Reply({
        required this.id,
        required this.reply,
        required this.createdAt,
        required this.user,
    });

    factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["id"],
        reply: json["reply"],
        createdAt: DateTime.parse(json["created_at"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "reply": reply,
        "created_at": createdAt.toIso8601String(),
        "user": user.toJson(),
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
