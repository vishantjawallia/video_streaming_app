import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_streaming_app/core/theme/app_theme.dart';

import '../../../../core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _profileImageUrl;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('user_name') ?? '';
    _emailController.text = prefs.getString('user_email') ?? '';
    _profileImageUrl = prefs.getString('user_profile_image');
    setState(() {});
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 75);

      if (image != null) {
        setState(() {
          _profileImageUrl = image.path;
        });
        // In real app, you would upload the image to server
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e'), backgroundColor: Colors.red));
    }
  }

  void _saveProfile() {
    // In real app, you would save to local storage or API
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final name = _nameController.text;
              final email = _emailController.text;
              final shareText = 'My Profile\nName: $name\nEmail: $email';
              Share.share(shareText, subject: 'My Profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Logout functionality
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_id');
              await prefs.remove('user_name');
              await prefs.remove('user_email');
              await prefs.remove('user_profile_image');
              context.go(AppConstants.loginRoute);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(children: [_buildProfileHeader(), SizedBox(height: 32.h), _buildProfileForm(), SizedBox(height: 32.h), _buildSettingsSection()]),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60.r,
              backgroundColor: Colors.grey[300],
              backgroundImage: _profileImageUrl != null ? FileImage(File(_profileImageUrl!)) : null,
              child: _profileImageUrl == null ? Icon(Icons.person, size: 60.w, color: Colors.grey[600]) : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                child: IconButton(icon: const Icon(Icons.camera_alt, color: Colors.white), onPressed: _pickImage),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text('John Doe', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        Text(_emailController.text ?? 'john.doe@example.com', style: TextStyle(fontSize: 16.sp, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Edit Profile', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Full Name', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _emailController,
          enabled: false,
          decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
            child: Text('Save Changes', style: TextStyle(fontSize: 16.sp)),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 16.h),
        _buildSettingsItem(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: () {
            // Navigate to notifications settings
          },
        ),
        _buildSettingsItem(
          icon: Icons.security,
          title: 'Privacy & Security',
          subtitle: 'Manage your privacy settings',
          onTap: () {
            // Navigate to privacy settings
          },
        ),
        _buildSettingsItem(
          icon: Icons.storage,
          title: 'Storage',
          subtitle: 'Manage app storage',
          onTap: () {
            // Navigate to storage settings
          },
        ),
        _buildSettingsItem(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {
            // Navigate to help screen
          },
        ),
        _buildSettingsItem(
          icon: Icons.info,
          title: 'About',
          subtitle: 'App version and information',
          onTap: () {
            // Navigate to about screen
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingsItem({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
