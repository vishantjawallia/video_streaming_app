import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String category;
  final int views;
  final int likes;
  final String author;
  final DateTime createdAt;
  final Duration duration;

  const Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.category,
    required this.views,
    required this.likes,
    required this.author,
    required this.createdAt,
    required this.duration,
  });

  @override
  List<Object?> get props => [id, title, description, thumbnailUrl, videoUrl, category, views, likes, author, createdAt, duration];
}
