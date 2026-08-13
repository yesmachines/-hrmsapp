class PaginationData {
  PaginationData({
    required this.totalPages,
    required this.currentPage,
    required this.lastPage,
  });

  int totalPages;
  int currentPage;
  int lastPage;

  factory PaginationData.fromJson(Map json) {
    return PaginationData(
      totalPages: json["total"],
      currentPage: json["current_page"],
      lastPage: json["last_page"],
    );
  }
}