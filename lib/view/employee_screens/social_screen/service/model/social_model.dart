class SocialReactionModel {
  final int id;
  final String userName;
  final String userImage;
  final String reaction;

  SocialReactionModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.reaction,
  });

  factory SocialReactionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SocialReactionModel(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      reaction: json['reaction'] ?? '👍',
    );
  }
}

class SocialPostModel {
  final int id;
  final String userName;
  final String userImage;
  final String postedTime;
  final String description;
  final String postImage;

  final List<String> reactions;
  final int reactionCount;

  final List<SocialReactionModel> reactionUsers;

  SocialPostModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.postedTime,
    required this.description,
    required this.postImage,
    required this.reactions,
    required this.reactionCount,
    required this.reactionUsers,
  });

  factory SocialPostModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SocialPostModel(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      postedTime: json['posted_time'] ?? '',
      description: json['description'] ?? '',
      postImage: json['post_image'] ?? '',
      reactions: List<String>.from(
        json['reactions'] ?? [],
      ),
      reactionCount: json['reaction_count'] ?? 0,
      reactionUsers:
      List<SocialReactionModel>.from(
        (json['reaction_users'] ?? []).map(
              (e) => SocialReactionModel.fromJson(e),
        ),
      ),
    );
  }
}

List<SocialPostModel> getSocialPostsFromJson(
    List json,
    ) {
  return List<SocialPostModel>.from(
    json.map(
          (e) => SocialPostModel.fromJson(e),
    ),
  );
}