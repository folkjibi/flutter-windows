// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class CachedImageExample extends StatefulWidget {
//   final String imageUrl;

//   CachedImageExample({required this.imageUrl});

//   @override
//   _CachedImageExampleState createState() => _CachedImageExampleState();
// }

// class _CachedImageExampleState extends State<CachedImageExample> {
//   // Function to cache the image manually
//   Future<void> cacheImage(String url) async {
//     var file = await DefaultCacheManager().getSingleFile(url);
//     print('Image downloaded and cached at: ${file.path}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Cache Image Example")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // Display image from cache or download it
//             CachedNetworkImage(
//               imageUrl:
//                   widget.imageUrl, // Use the imageUrl passed to the widget
//               placeholder: (context, url) => CircularProgressIndicator(),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//               cacheManager:
//                   DefaultCacheManager(), // Use the default cache manager
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 // Trigger image cache manually
//                 await cacheImage(widget.imageUrl);
//               },
//               child: Text('Cache Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
