class AcademyCategory {
  final String id;
  final String name;

  const AcademyCategory({
    required this.id,
    required this.name,
  });

  factory AcademyCategory.fromJson(Map<String, dynamic> json) {
    return AcademyCategory(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
    );
  }
}

class AcademyVideo {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final String youtubeUrl;
  final String? thumbnailUrl;
  final int? durationSeconds;

  const AcademyVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.youtubeUrl,
    this.thumbnailUrl,
    this.durationSeconds,
  });

  String get youtubeId {
    final uri = Uri.tryParse(youtubeUrl);
    if (uri == null) return '';
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    }
    return uri.queryParameters['v'] ?? '';
  }

  String get resolvedThumbnail {
    if ((thumbnailUrl ?? '').trim().isNotEmpty) return thumbnailUrl!.trim();
    final id = youtubeId;
    if (id.isEmpty) return '';
    return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
  }

  factory AcademyVideo.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    String categoryId = '';
    String categoryName = '';
    if (category is Map) {
      categoryId = (category['_id'] ?? category['id'] ?? '').toString();
      categoryName = (category['name'] ?? category['title'] ?? '').toString();
    } else {
      categoryId = (json['categoryId'] ?? '').toString();
      categoryName = (json['categoryName'] ?? '').toString();
    }

    return AcademyVideo(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      categoryId: categoryId,
      categoryName: categoryName,
      youtubeUrl: (json['youtubeUrl'] ?? json['videoUrl'] ?? '').toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
    );
  }
}
