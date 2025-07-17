import '../../domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.videoUrl,
    required super.category,
    required super.views,
    required super.likes,
    required super.author,
    required super.createdAt,
    required super.duration,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      videoUrl: json['video_url'] as String,
      category: json['category'] as String,
      views: json['views'] as int,
      likes: json['likes'] as int,
      author: json['author'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      duration: Duration(seconds: json['duration_seconds'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'category': category,
      'views': views,
      'likes': likes,
      'author': author,
      'created_at': createdAt.toIso8601String(),
      'duration_seconds': duration.inSeconds,
    };
  }
}
