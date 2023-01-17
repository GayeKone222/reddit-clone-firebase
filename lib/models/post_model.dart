// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String type;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfilePic;
  final List<String> upVotes;
  final List<String> downVotes;
  final int commentCount;
  final String userName;
  final String userUid;
  final DateTime createdAt;
  final List<String> awards;
  Post({
    required this.id,
    required this.title,
    required this.type,
    this.link,
    this.description,
    required this.communityName,
    required this.communityProfilePic,
    required this.upVotes,
    required this.downVotes,
    required this.commentCount,
    required this.userName,
    required this.userUid,
    required this.createdAt,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? type,
    String? link,
    String? description,
    String? communityName,
    String? communityProfilePic,
    List<String>? upVotes,
    List<String>? downVotes,
    int? commentCount,
    String? userName,
    String? userUid,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      userName: userName ?? this.userName,
      userUid: userUid ?? this.userUid,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'type': type,
      'link': link,
      'description': description,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'userName': userName,
      'userUid': userUid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
        id: map['id'] as String,
        title: map['title'] as String,
        type: map['type'] as String,
        link: map['link'] != null ? map['link'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        communityName: map['communityName'] as String,
        communityProfilePic: map['communityProfilePic'] as String,
        upVotes: List<String>.from((map['upVotes']  )),
        downVotes: List<String>.from((map['downVotes'] )),
        commentCount: map['commentCount'] as int,
        userName: map['userName'] as String,
        userUid: map['userUid'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        awards: List<String>.from(
          (map['awards']  ),
        ));
  }

  // String toJson() => json.encode(toMap());

  // factory Post.fromJson(String source) => Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, title: $title, type: $type, link: $link, description: $description, communityName: $communityName, communityProfilePic: $communityProfilePic, upVotes: $upVotes, downVotes: $downVotes, commentCount: $commentCount, userName: $userName, userUid: $userUid, createdAt: $createdAt, awards: $awards)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.type == type &&
        other.link == link &&
        other.description == description &&
        other.communityName == communityName &&
        other.communityProfilePic == communityProfilePic &&
        listEquals(other.upVotes, upVotes) &&
        listEquals(other.downVotes, downVotes) &&
        other.commentCount == commentCount &&
        other.userName == userName &&
        other.userUid == userUid &&
        other.createdAt == createdAt &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        type.hashCode ^
        link.hashCode ^
        description.hashCode ^
        communityName.hashCode ^
        communityProfilePic.hashCode ^
        upVotes.hashCode ^
        downVotes.hashCode ^
        commentCount.hashCode ^
        userName.hashCode ^
        userUid.hashCode ^
        createdAt.hashCode ^
        awards.hashCode;
  }
}
