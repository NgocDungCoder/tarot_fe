import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarot_fe/models/blog_entity.dart';

import '../../../../configs/styles/theme_config.dart';
import '../../../../widget/custom_text.dart';

class BlogItemWidget extends StatelessWidget{
  final BlogEntity blog;
  const BlogItemWidget( {super.key, required this.blog,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to blog detail
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: ThemeConfig.textGold.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Blog image
              Image.network(
                blog.featuredImage ?? "",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ThemeConfig.deepPurple.withOpacity(0.5),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: ThemeConfig.textGold,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        blog.title ?? 'Blog Title',
                        fontSize: 18,
                        color: ThemeConfig.textWhite,
                        fontWeight: FontWeight.bold,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        blog.excerpt ?? 'Blog description',
                        fontSize: 12,
                        color: ThemeConfig.textWhite.withOpacity(0.8),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}