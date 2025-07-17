import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTabs extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryTabs({super.key, required this.selectedCategory, required this.onCategoryChanged});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Education', 'Programming', 'Entertainment', 'Sports', 'Music'];

    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: FilterChip(
              label: Text(category, style: TextStyle(fontSize: 14.sp, color: isSelected ? Colors.white : Colors.grey[700])),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCategoryChanged(category);
                }
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300, width: 1),
            ),
          );
        },
      ),
    );
  }
}
