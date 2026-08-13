import 'package:yes_hrm/common_model/pagination_data_model.dart';

import 'idea_status_enum.dart';

class IdeaDataModel {
  IdeaDataModel({required this.ideas, required this.paginationData});

  List<IdeaItem> ideas;
  PaginationData paginationData;

  factory IdeaDataModel.fromJson(Map json) {
    return IdeaDataModel(
      ideas: getIdeaItemFromJson(json["ideas"]),
      paginationData: PaginationData.fromJson(json["pagination"]),
    );
  }
}

List<IdeaItem> getIdeaItemFromJson(List json) =>
    List.from(json.map((e) => IdeaItem.fromJson(e)));

class IdeaItem {
  const IdeaItem({
    required this.id,
    required this.title,
    required this.description,
    required this.ideaFiles,
    required this.date,
    required this.status,
    this.reviewer,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final List<String> ideaFiles;
  final IdeaStatus status;
  final IdeaReviewerModel? reviewer;

  factory IdeaItem.fromJson(Map json) {
    List ideaFiles = json["idea_files"];
    return IdeaItem(
      id: json["id"].toString(),
      title: json["title"],
      description: json["description"],
      ideaFiles: ideaFiles.map((e) => e.toString()).toList(),
      date: DateTime.parse(json["created_at"]),
      status: IdeaStatus.fromString(json["status"]),
      reviewer: json["review_comment"] != null
          ? IdeaReviewerModel(
              reviewerName: "HR Manager",
              reviewerRole: "Human Resource Manager",
              reviewDate: DateTime.now(),
              reviewComment: json["review_comment"],
            )
          : null,
    );
  }
}

class IdeaReviewerModel {
  IdeaReviewerModel({
    required this.reviewerName,
    required this.reviewerRole,
    required this.reviewDate,
    required this.reviewComment,
  });

  final String reviewerName;
  final String reviewerRole;
  final DateTime reviewDate;
  final String reviewComment;
}
