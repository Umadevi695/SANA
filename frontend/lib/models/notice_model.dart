class NoticeModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String filePath;
  final bool isApproved;
  final String attachmentName;
  final bool isRead;
  final bool isDownloaded;
  

  NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
     required this.filePath,
    this.isApproved = false,
    this.attachmentName = "No attachment",
    this.isRead = false,
    this.isDownloaded = false,
  });

   factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      description: json["summary"] ?? "",
      category: json["category"] ?? "Other",
      date: json["deadline"] ?? "",
      attachmentName: json["fileName"] ?? "No attachment",
      filePath: json["filePath"] ?? "",
      isApproved: true,

    );
  }

  NoticeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? date,
    String? filePath,
    bool? isApproved,
    String? attachmentName,
    bool? isRead,
    bool? isDownloaded,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      filePath: filePath ?? this.filePath,
      isApproved: isApproved ?? this.isApproved,
      attachmentName: attachmentName ?? this.attachmentName,
      isRead: isRead ?? this.isRead,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
