import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photory/post/service/post_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:photory/post_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture, Name & Timestamp Row

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 8,
                  color: Colors.grey[1000],
                ),
                // Profile Picture
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: post.profilePicture,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        CircularProgressIndicator(strokeWidth: 2),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 8),
                // Name and Timestamp Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      post.createdTimestamp,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),

            // Post Text
            child: Text(
              post.postText,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Post Image
          if (post.imageUrl.isNotEmpty) ...[
            const SizedBox(height: 8),
            CachedNetworkImage(
              imageUrl: post.imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Likes, Comments, Shares
                Row(
                  children: [
                    Icon(Icons.thumb_up, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post.likeCount}'),
                    const SizedBox(width: 16),
                    Icon(Icons.comment, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post.commentCount}'),
                    const SizedBox(width: 16),
                    Icon(Icons.share, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post.shareCount}'),
                  ],
                ),
                // View Count
                Row(
                  children: [
                    Icon(Icons.remove_red_eye, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post.viewCount}'),
                  ],
                ),
              ],
            ),
          ),
          post.likeString == ""
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        post.likeString,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

          FutureBuilder<List<Comment>>(
            future: post.comments,
            builder: (context, snapshot) {
              // Show loading animation while waiting
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Handle errors
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Error loading comments: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              // Handle empty or null data
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox
                    .shrink(); // Or show an "empty comments" message
              }

              // Show comments when data is available
              final comments = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                  children: comments.map((comment) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8),

                          // Name & Comment Bubble
                          Expanded(
                            // Ensures text wraps inside available space
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    comment.commentText,
                                    style: const TextStyle(fontSize: 14),
                                    softWrap:
                                        true, // Ensures long text wraps properly
                                    overflow: TextOverflow
                                        .visible, // Allows text to expand
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          SizedBox(height: 12),
          Container(
            height: 8,
            color: Color(0xFFE1E1E0),
          ),
        ],
      ),
    );
  }
}
