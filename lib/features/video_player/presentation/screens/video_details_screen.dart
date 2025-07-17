import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/video_player_widget.dart';

class VideoDetailsScreen extends StatefulWidget {
  final String videoId;

  const VideoDetailsScreen({super.key, required this.videoId});

  @override
  State<VideoDetailsScreen> createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  bool _isLiked = false;
  bool _isBookmarked = false;

  // Mock video data - in real app, this would come from API
  final Map<String, dynamic> _videoData = {
    'id': '1',
    'title': 'Flutter Tutorial for Beginners',
    'description': 'Learn Flutter from scratch with this comprehensive tutorial. This video covers all the basics you need to know to get started with Flutter development.',
    'thumbnailUrl': 'https://picsum.photos/300/200',
    'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'category': 'Education',
    'views': 15000,
    'likes': 1200,
    'author': 'Flutter Team',
    'duration': Duration(minutes: 15, seconds: 30),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text(_videoData['title'], style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('Check out this video: ${_videoData['title']}', subject: _videoData['title']);
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: CustomScrollView(
        slivers: [
          // SizedBox(height: 250.h, width: double.infinity, child: FlexibleSpaceBar(background: VideoPlayerWidget(videoUrl: _videoData['videoUrl'], thumbnailUrl: _videoData['thumbnailUrl']))),
          SliverAppBar(
            collapsedHeight: 0,
            toolbarHeight: 0,
            expandedHeight: 220.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(background: VideoPlayerWidget(videoUrl: _videoData['videoUrl'], thumbnailUrl: _videoData['thumbnailUrl'])),
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
            actions: [
              IconButton(
                icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  Share.share('Check out this video: ${_videoData['title']}', subject: _videoData['title']);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_videoData['title'], style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(_formatViews(_videoData['views']), style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                      SizedBox(width: 16.w),
                      Text(_formatDuration(_videoData['duration']), style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      CircleAvatar(radius: 20.r, backgroundColor: Colors.grey[300], child: Icon(Icons.person, color: Colors.grey[600])),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_videoData['author'], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                            Text('Verified Creator', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Subscribe functionality
                        },
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
                        child: const Text('Subscribe'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isLiked = !_isLiked;
                            });
                          },
                          icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : null),
                          label: Text(_isLiked ? 'Liked' : 'Like', style: TextStyle(color: _isLiked ? Colors.red : null)),
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Comment functionality
                          },
                          icon: const Icon(Icons.comment),
                          label: const Text('Comment'),
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text('Description', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text(_videoData['description'], style: TextStyle(fontSize: 14.sp, color: Colors.grey[700], height: 1.5)),
                  SizedBox(height: 24.h),
                  Text('Comments', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.h),
                  _buildCommentSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    final comments = [
      {'author': 'John Doe', 'comment': 'Great tutorial! Very helpful for beginners.', 'time': '2 hours ago', 'likes': 5},
      {'author': 'Jane Smith', 'comment': 'I learned a lot from this video. Thanks!', 'time': '1 day ago', 'likes': 3},
    ];

    return Column(
      children:
          comments.map((comment) {
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 16.r, backgroundColor: Colors.grey[300], child: Icon(Icons.person, size: 16.w, color: Colors.grey[600])),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(comment['author'] as String, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                            SizedBox(width: 8.w),
                            Text(comment['time'] as String, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(comment['comment'] as String, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(Icons.thumb_up_outlined, size: 16.w, color: Colors.grey[600]),
                            SizedBox(width: 4.w),
                            Text((comment['likes'] as int).toString(), style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                            SizedBox(width: 16.w),
                            Text('Reply', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    } else {
      return '$views views';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
