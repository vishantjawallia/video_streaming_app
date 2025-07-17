import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/video_player_widget.dart';
import '../../../home/data/datasources/demo_video_data.dart';
import '../../../home/data/models/video_model.dart';

class VideoDetailsScreen extends StatefulWidget {
  final String videoId;

  const VideoDetailsScreen({super.key, required this.videoId});

  @override
  State<VideoDetailsScreen> createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  bool _isLiked = false;
  bool _isBookmarked = false;

  VideoModel? _video;
  bool _isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _fetchVideoDetails();
    });
    super.initState();
  }

  Future<void> _fetchVideoDetails() async {
    // Simulate network delay for shimmer effect
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      _video = demoVideos.firstWhere((v) => v.id == widget.videoId, orElse: () => null!);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
          title: Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 120.w, height: 20.h, color: Colors.white)),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: _buildShimmerBody(context),
      );
    }

    if (_video == null) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()), title: const Text('Video Not Found')),
        body: Center(child: Text('Video not found')),
      );
    }
    // log("_video!.videoUrl===>${{_video!.videoUrl}}")
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text(_video!.title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
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
              Share.share('Check out this video: ${_video!.title}', subject: _video!.title);
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 210.h, width: double.infinity, child: VideoPlayerWidget(videoUrl: _video!.videoUrl, thumbnailUrl: _video!.thumbnailUrl)),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_video!.title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(_formatViews(_video!.views), style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                      SizedBox(width: 16.w),
                      Text(_formatDuration(_video!.duration), style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
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
                            Text(_video!.author, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
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
                  Text(_video!.description, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700], height: 1.5)),
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

      // body: CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //       collapsedHeight: 0,
      //       toolbarHeight: 0,
      //       expandedHeight: 220.h,
      //       pinned: true,
      //       flexibleSpace: FlexibleSpaceBar(background: VideoPlayerWidget(videoUrl: _video!.videoUrl, thumbnailUrl: _video!.thumbnailUrl)),
      //       leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      //       actions: [
      //         IconButton(
      //           icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      //           onPressed: () {
      //             setState(() {
      //               _isBookmarked = !_isBookmarked;
      //             });
      //           },
      //         ),
      //         IconButton(
      //           icon: const Icon(Icons.share),
      //           onPressed: () {
      //             Share.share('Check out this video: ${_video!.title}', subject: _video!.title);
      //           },
      //         ),
      //       ],
      //     ),
      //     SliverToBoxAdapter(
      //       child: Padding(
      //         padding: EdgeInsets.all(16.w),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(_video!.title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
      //             SizedBox(height: 8.h),
      //             Row(
      //               children: [
      //                 Text(_formatViews(_video!.views), style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
      //                 SizedBox(width: 16.w),
      //                 Text(_formatDuration(_video!.duration), style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
      //               ],
      //             ),
      //             SizedBox(height: 16.h),
      //             Row(
      //               children: [
      //                 CircleAvatar(radius: 20.r, backgroundColor: Colors.grey[300], child: Icon(Icons.person, color: Colors.grey[600])),
      //                 SizedBox(width: 12.w),
      //                 Expanded(
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(_video!.author, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
      //                       Text('Verified Creator', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
      //                     ],
      //                   ),
      //                 ),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     // Subscribe functionality
      //                   },
      //                   style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
      //                   child: const Text('Subscribe'),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(height: 16.h),
      //             Row(
      //               children: [
      //                 Expanded(
      //                   child: OutlinedButton.icon(
      //                     onPressed: () {
      //                       setState(() {
      //                         _isLiked = !_isLiked;
      //                       });
      //                     },
      //                     icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : null),
      //                     label: Text(_isLiked ? 'Liked' : 'Like', style: TextStyle(color: _isLiked ? Colors.red : null)),
      //                     style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
      //                   ),
      //                 ),
      //                 SizedBox(width: 12.w),
      //                 Expanded(
      //                   child: OutlinedButton.icon(
      //                     onPressed: () {
      //                       // Comment functionality
      //                     },
      //                     icon: const Icon(Icons.comment),
      //                     label: const Text('Comment'),
      //                     style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             SizedBox(height: 24.h),
      //             Text('Description', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      //             SizedBox(height: 8.h),
      //             Text(_video!.description, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700], height: 1.5)),
      //             SizedBox(height: 24.h),
      //             Text('Comments', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      //             SizedBox(height: 16.h),
      //             _buildCommentSection(),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildShimmerBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          collapsedHeight: 0,
          toolbarHeight: 0,
          expandedHeight: 220.h,
          pinned: true,
          flexibleSpace: Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(color: Colors.grey[300], width: double.infinity, height: 220.h)),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 200.w, height: 24.h, color: Colors.white)),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 60.w, height: 16.h, color: Colors.white)),
                    SizedBox(width: 16.w),
                    Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 40.w, height: 16.h, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: CircleAvatar(radius: 20.r, backgroundColor: Colors.white)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 100.w, height: 16.h, color: Colors.white)),
                          SizedBox(height: 4.h),
                          Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 60.w, height: 12.h, color: Colors.white)),
                        ],
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(width: 80.w, height: 32.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r))),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(height: 40.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r))),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(height: 40.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r))),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 120.w, height: 20.h, color: Colors.white)),
                SizedBox(height: 8.h),
                Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: double.infinity, height: 60.h, color: Colors.white)),
                SizedBox(height: 24.h),
                Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 120.w, height: 20.h, color: Colors.white)),
                SizedBox(height: 16.h),
                ...List.generate(2, (index) => _buildShimmerComment()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerComment() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: CircleAvatar(radius: 16.r, backgroundColor: Colors.white)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 60.w, height: 14.h, color: Colors.white)),
                    SizedBox(width: 8.w),
                    Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 40.w, height: 12.h, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 4.h),
                Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: double.infinity, height: 14.h, color: Colors.white)),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 16.w, height: 16.h, color: Colors.white)),
                    SizedBox(width: 4.w),
                    Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 20.w, height: 12.h, color: Colors.white)),
                    SizedBox(width: 16.w),
                    Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 40.w, height: 12.h, color: Colors.white)),
                  ],
                ),
              ],
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
