// import 'package:flutter/material.dart';
// import 'package:photory/post_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PostListPage extends StatefulWidget {
//   @override
//   _PostListPageState createState() => _PostListPageState();
// }

// class _PostListPageState extends State<PostListPage> {
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoadingMore = false;
//   bool _hasMoreData = true;
//   final PostService postService = PostService();

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialPosts();
//     _scrollController.addListener(_onScroll);
//   }

//   Future<void> checkConnection() async {
//     try {
//       // Attempt to fetch a document from a known collection
//       DocumentSnapshot snapshot =
//           await firestore.collection('posts').doc('06rJzZtUUfMZxnmAr6m3').get();

//       if (snapshot.exists) {
//         print('Connected to Firestore! Document data: ${snapshot.data()}');
//       } else {
//         print('Document does not exist.');
//       }
//     } catch (e) {
//       print('Error connecting to Firestore: $e');
//     }
//   }

//   Future<void> _loadInitialPosts() async {
//     await postService.fetchPosts();
//     setState(() {});
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.8) {
//       _loadMorePosts();
//     }
//   }

//   Future<void> _loadMorePosts() async {
//     if (!_hasMoreData || _isLoadingMore) return;

//     setState(() => _isLoadingMore = true);

//     final newPosts = await postService.fetchPosts();
//     setState(() {
//       _isLoadingMore = false;
//       _hasMoreData = newPosts.isNotEmpty;
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Posts'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () async {
//               await postService.fetchPosts();
//               setState(() {});
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.safety_check),
//             onPressed: () async {
//               await checkConnection();
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: postService.posts.length,
//               itemBuilder: (context, index) {
//                 final post = postService.posts[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 8.0, horizontal: 16.0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           post.displayName,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           post.postText,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         Image.network(post.imageUrl),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (_isLoadingMore)
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: CircularProgressIndicator(),
//             ),
//           if (!_hasMoreData)
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text('No more posts to load'),
//             ),
//         ],
//       ),
//     );
//   }
// }
