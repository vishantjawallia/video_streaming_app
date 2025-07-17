import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../models/video_model.dart';
import 'demo_video_data.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getVideos({String? category, String? search});
  Future<VideoModel> getVideoById(String id);
  Future<List<String>> getCategories();
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final http.Client client;

  const VideoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<VideoModel>> getVideos({String? category, String? search}) async {
    await Future.delayed(const Duration(seconds: 1));
    return demoVideos;
  }

  @override
  Future<VideoModel> getVideoById(String id) async {
    await Future.delayed(const Duration(seconds: 1));

    return VideoModel(
      id: '1',
      title: 'Flutter Tutorial for Beginners',
      description: 'Learn Flutter from scratch with this comprehensive tutorial.',
      thumbnailUrl: 'https://picsum.photos/300/200',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      category: 'Education',
      views: 15000,
      likes: 1200,
      author: 'Flutter Team',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      duration: Duration(minutes: 15, seconds: 30),
    );
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return ['All', 'Education', 'Programming', 'Entertainment', 'Sports', 'Music'];
  }
}
