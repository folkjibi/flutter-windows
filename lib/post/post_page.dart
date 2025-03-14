import 'package:flutter/material.dart';
import 'package:photory/post/post_card.dart';
import 'package:photory/post/service/post_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class PostListPage extends StatefulWidget {
  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  final PostService postService = PostService();
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadInitialPosts() async {
    await postService.fetchPosts();
    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    if (!_hasMoreData || _isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    final newPosts = await postService.fetchPosts();
    setState(() {
      _isLoadingMore = false;
      _hasMoreData = newPosts.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[500],
      // ),
      body: Container(
        color: Color(0xFFE1E1E0),
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverAppBar(
                floating: true,
                title: Text('Posts'),
                backgroundColor: Color(0xFFE1E1E0),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = postService.posts[index];
                    return PostCard(post: post);
                  },
                  childCount: postService.posts.length,
                ),
                // separatorBuilder:
              ),
            ],
          ),
        ),
      ),

      // Column(
      //   children: [
      //     AnimatedContainer(
      //       duration: Duration(milliseconds: 200),
      //       height: _isAppBarVisible ? 120 : 60,
      //       child: AppBar(
      //         title: const Text('Posts'),
      //         backgroundColor: Colors.grey[300],
      //         elevation: 0,
      //       ),
      //     ),
      //     Expanded(
      //       child: ListView.separated(
      //         controller: _scrollController,
      //         itemCount: postService.posts.length,
      //         separatorBuilder: (context, index) => Container(
      //           height: 8,
      //           color: Colors.grey[300],
      //         ),
      //         itemBuilder: (context, index) {
      //           final post = postService.posts[index];
      //           return PostCard(post: post);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
