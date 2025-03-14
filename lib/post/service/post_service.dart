import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photory/service/flutter_cache_manager.dart';
import 'dart:math';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class Post {
  String postId;
  String displayName;
  String postText;
  String imageUrl;
  String profilePicture;
  String createdTimestamp;
  int likeCount;
  int commentCount;
  int shareCount;
  int viewCount;
  String likeString;
  Future<List<Comment>> comments;

  Post({
    required this.postId,
    required this.displayName,
    required this.postText,
    required this.imageUrl,
    required this.profilePicture,
    required this.createdTimestamp,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.viewCount,
    required this.likeString,
    required this.comments,
  });
}

class Comment {
  String commentId;
  String displayName;
  String commentText;
  Comment({
    required this.commentId,
    required this.displayName,
    required this.commentText,
  });
}

class Like {
  // final String likeId;
  // final String postId;
  final String displayName;
  // final DateTime timestamp;

  Like({
    // required this.likeId,
    // required this.postId,
    required this.displayName,
    // required this.timestamp,
  });
}

class PostService {
  final ImageCacheService _imageCacheService = ImageCacheService();
  QueryDocumentSnapshot? lastDocument;
  // QueryDocumentSnapshot? lastComment;
  List<Post> posts = [];
  final random = Random();

  Future<List<Post>> fetchPosts({int limit = 8}) async {
    List<Post> filterPosts = [];
    try {
      Query query = firestore
          .collection('posts')
          // .where('commentCount', isGreaterThan: 0)
          .orderBy('createdTimestamp', descending: true)
          .limit(limit);
      print('a');

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }
      print('b');

      try {
        print('c');
        QuerySnapshot querySnapshot = await query.get();
        print('d');

        final newPosts = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        print(newPosts.length);

        // print(newPosts.length);
        for (var post in newPosts) {
          String postId = (post['postId'] as String?) ?? '';
          if (postId.isEmpty) {
            continue;
          }
          // print("a");
          // print(
          //     "displayName: ${post['displayName']} - Type: ${post['displayName'].runtimeType}");
          String displayName = (post['displayName'] as String?) ?? 'Anonymous';
          // print(displayName);
          // print(
          //     "postText: ${post['postText']} - Type: ${post['postText'].runtimeType}");
          String postText =
              (post['postText'] as String?) ?? 'No content available';
          // print(postText);
          // print(
          //     "createdTimestamp: ${post['createdTimestamp']} - Type: ${post['createdTimestamp'].runtimeType}");
          Timestamp createdTimestamp;

          if (post['createdTimestamp'] != null &&
              post['createdTimestamp'] is Timestamp) {
            // } && post['createdTimestamp']  != undefined) {
            // print(post['postId']);
            // print("A");

            // createdTimestamp =
            //     Timestamp.now();
            createdTimestamp = post['createdTimestamp'] as Timestamp;
          } else {
            createdTimestamp = Timestamp.now();
          }
          // print(post['createdTimestamp']);
          // print(createdTimestamp);
          // String createdTimestamp = "createdTimestamp";
          // print(
          //     "likeCount: ${post['likeCount']} - Type: ${post['likeCount'].runtimeType}");
          int likeCount = (post['likeCount'] is num)
              ? (post['likeCount'] as num).toInt()
              : 0;
          // print(likeCount);
          // print(
          //     "commentCount: ${post['commentCount']} - Type: ${post['commentCount'].runtimeType}");
          int commentCount = (post['commentCount'] is num)
              ? (post['commentCount'] as num).toInt()
              : 0;
          // print(commentCount);
          // print(
          //     "shareCount: ${post['shareCount']} - Type: ${post['shareCount'].runtimeType}");
          int shareCount = (post['shareCount'] is num)
              ? (post['shareCount'] as num).toInt()
              : 0;

          // print(shareCount);
          // print(
          //     "viewCount: ${post['viewCount']} - Type: ${post['viewCount'].runtimeType}");
          int viewCount = (post['viewCount'] is num)
              ? (post['viewCount'] as num).toInt()
              : 0;

          // print(viewCount);
          // print(
          //     "imageUrl: ${post['imageUrl']} - Type: ${post['imageUrl'].runtimeType}");
          String imageUrl = '';
          if (post['sceneData'][0]['image'] != null &&
              post['sceneData'][0]['image'].isNotEmpty) {
            imageUrl = (post['sceneData'][0]['image'] as String);
          }
          // print(imageUrl);
          // print(
          //     "profilePicture: ${post['profilePicture']} - Type: ${post['profilePicture'].runtimeType}");
          String profilePicture = (post['profilePicture'] as String?) ?? '';

          // print(profilePicture);
          // List<Comment> comment = await getCommentsForPost(postId);

          String likeString = '';
          final choice = random.nextBool();
          if (choice) {
            likeString = displayName;
          }
          // List<Like> like = await getLikesForPost(postId);
          // if (like.isEmpty) likeString = "";
          // if (like.length == 1) likeString = like[0].displayName;
          // if (like.length == 2) {
          //   likeString = '${like[0].displayName} and ${like[1].displayName}';
          // }
          // likeString =
          //     '${like[0].displayName} and ${like[1].displayName} and others';

          filterPosts.add(Post(
            postId: postId,
            displayName: displayName,
            postText: postText,
            imageUrl: imageUrl,
            profilePicture: profilePicture,
            createdTimestamp: timeToString(createdTimestamp),
            likeCount: likeCount,
            commentCount: commentCount,
            shareCount: shareCount,
            viewCount: viewCount,
            likeString: likeString,
            comments: getCommentsForPost(postId),
          ));
          // _imageCacheService.cacheImage(imageUrl);
          // _imageCacheService.cacheImage(profilePicture);
        }

        if (querySnapshot.docs.isNotEmpty) {
          lastDocument = querySnapshot.docs.last;
        }

        posts.addAll(filterPosts);
      } catch (e) {
        print('Error fetching data: $e');
        // setState(() {
        //   _errorMessage = 'Failed to fetch data: ${e.toString()}';
        // });
      } finally {
        // setState(() {
        //   _isLoading = false;
        // });
      }
      return filterPosts;
    } catch (e) {
      return [];
    }
  }

  Future<List<Comment>> getCommentsForPost(String postId) async {
    List<Comment> comments = [];
    // Generate a random boolean (true or false)
    final choice = random.nextBool();
    if (choice) {
      return [];
    }

    try {
      Query query = firestore.collection('postComments').limit(1);
      // if (lastComment != null) {
      //   query = query.startAfterDocument(lastComment!);
      // }
      QuerySnapshot querySnapshot = await query.get();

      // if (querySnapshot.docs.isNotEmpty) {
      //   lastComment = querySnapshot.docs.last;
      // }

      comments = querySnapshot.docs.map((doc) {
        return Comment(
          commentId: doc.id,
          displayName: doc['displayName'],
          commentText: doc['commentText'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
    } finally {}

    return comments;
  }
}

Future<List<Like>> getLikesForPost(String postId) async {
  List<Like> likes = [];

  try {
    // Create the initial query
    Query query = firestore
        .collection('postLikes')
        .where('postId', isEqualTo: postId)
        .limit(10); // Adjust limit as needed

    // Execute the query
    QuerySnapshot querySnapshot = await query.get();

    // Map documents to Like objects
    likes = querySnapshot.docs.map((doc) {
      return Like(
        // likeId: doc.id,
        // postId: doc['postId'],
        displayName: doc['displayName'],
        // Add other fields you might have
        // timestamp: doc['timestamp']?.toDate() ?? DateTime.now(),
      );
    }).toList();
  } catch (e) {
    print('Error fetching likes: $e');
  }

  return likes;
}

String timeToString(Timestamp createdTimestamp) {
  DateTime createdAt =
      createdTimestamp.toDate(); // Convert Firestore Timestamp to DateTime
  DateTime now = DateTime.now();
  Duration diff = now.difference(createdAt); // Calculate time difference

  if (diff.inHours < 1) {
    return "${diff.inMinutes} m"; // Minutes ago
  } else if (diff.inDays < 1) {
    return "${diff.inHours} h"; // Hours ago
  } else if (diff.inDays < 30) {
    return "${diff.inDays} D"; // Days ago
  } else if (diff.inDays < 365) {
    int months = (diff.inDays / 30).floor(); // Approximate months
    return "${months} M"; // Months ago
  } else {
    int years = (diff.inDays / 365).floor(); // Approximate years
    return "${years} Y"; // Years ago
  }
}
