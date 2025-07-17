import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/home_bloc.dart';
import '../widgets/video_card.dart';
import '../widgets/category_tabs.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/platform_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadVideos());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<HomeBloc>().add(SearchVideos(query));
    } else {
      context.read<HomeBloc>().add(const LoadVideos());
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    if (category == 'All') {
      context.read<HomeBloc>().add(const LoadVideos());
    } else {
      context.read<HomeBloc>().add(FilterByCategory(category));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120.h,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Video Streaming', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, shadows: [Shadow(blurRadius: 8, color: Colors.black26)])),
                background: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]))),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: VideoSearchDelegate(onSearch: _onSearch));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    context.push(AppConstants.profileRoute);
                  },
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            CategoryTabs(selectedCategory: _selectedCategory, onCategoryChanged: _onCategoryChanged),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return _buildLoadingShimmer();
                  } else if (state is HomeLoaded) {
                    return _buildVideoList(state.videos);
                  } else if (state is HomeError) {
                    return _buildErrorWidget(state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey[100]!,
          child: Container(height: 200.h, margin: EdgeInsets.only(bottom: 16.h), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
        );
      },
    );
  }

  Widget _buildVideoList(List videos) {
    if (videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.video_library_outlined, size: 80.w, color: Colors.grey), SizedBox(height: 16.h), Text('No videos found', style: TextStyle(fontSize: 18.sp, color: Colors.grey))],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoCard(
          video: video,
          onTap: () {
            context.push('/video/${video.id}');
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80.w, color: Colors.red),
          SizedBox(height: 16.h),
          Text('Error', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Text(message, style: TextStyle(fontSize: 14.sp, color: Colors.grey), textAlign: TextAlign.center),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(const LoadVideos());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class VideoSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  VideoSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
