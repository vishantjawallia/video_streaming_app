import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(title: 'Welcome to Video Streaming', description: 'Discover amazing videos from creators around the world', icon: Icons.play_circle_fill, color: Colors.blue),
    OnboardingPage(title: 'High Quality Content', description: 'Enjoy crystal clear videos with the best streaming experience', icon: Icons.high_quality, color: Colors.green),
    OnboardingPage(title: 'Personalized Experience', description: 'Get recommendations based on your interests and preferences', icon: Icons.person, color: Colors.orange),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.isOnboardedKey, true);
    if (mounted) {
      context.go(AppConstants.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 200.w, height: 200.w, decoration: BoxDecoration(color: page.color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(page.icon, size: 100.w, color: page.color)),
          SizedBox(height: 40.h),
          Text(page.title, style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headlineMedium?.color), textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          Text(page.description, style: TextStyle(fontSize: 16.sp, color: Theme.of(context).textTheme.bodyMedium?.color), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: WormEffect(dotHeight: 8.h, dotWidth: 8.w, activeDotColor: Theme.of(context).primaryColor, dotColor: Colors.grey.withOpacity(0.5)),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                TextButton(
                  onPressed: () {
                    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: Text('Previous', style: TextStyle(fontSize: 16.sp)),
                )
              else
                const SizedBox.shrink(),
              ElevatedButton(
                onPressed:
                    _currentPage == _pages.length - 1
                        ? _completeOnboarding
                        : () {
                          _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        },
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h)),
                child: Text(_currentPage == _pages.length - 1 ? 'Get Started' : 'Next', style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({required this.title, required this.description, required this.icon, required this.color});
}
