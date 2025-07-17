import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/video.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback onTap;

  const VideoCard({super.key, required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    height: 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(height: 200.h, color: Colors.grey[300], child: const Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Container(height: 200.h, color: Colors.grey[300], child: const Icon(Icons.error)),
                  ),
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(4.r)),
                      child: Text(_formatDuration(video.duration), style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4.r)),
                      child: Text(video.category, style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 8.h),
                  Text(video.author, style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 16.w, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Text(_formatViews(video.views), style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                      SizedBox(width: 16.w),
                      Icon(Icons.favorite, size: 16.w, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Text(_formatViews(video.likes), style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }
}
