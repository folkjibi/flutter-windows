import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheService {
  // final List<String> imageUrls = [
  //   'https://example.com/image1.jpg',
  //   'https://example.com/image2.jpg',
  //   'https://example.com/image3.jpg',
  // ]; // Replace with your actual URLs

  // Pre-cache all images
  Future<void> cacheImage(String imageUrl) async {
    try {
      await DefaultCacheManager().getSingleFile(imageUrl);
      print('Cached image: $imageUrl');
    } catch (e) {
      print('Failed to cache image: $imageUrl, Error: $e');
    }
  }

  Future<void> cacheAllImages(List<String> imageUrls) async {
    for (var imageUrl in imageUrls) {
      try {
        await DefaultCacheManager().getSingleFile(imageUrl);
        print('Cached image: $imageUrl');
      } catch (e) {
        print('Failed to cache image: $imageUrl, Error: $e');
      }
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class CacheImagesApp extends StatefulWidget {
//   @override
//   _CacheImagesAppState createState() => _CacheImagesAppState();
// }

// class _CacheImagesAppState extends State<CacheImagesApp> {
//   // final List<String> imageUrls = [
//   //   'https://example.com/image1.jpg',
//   //   'https://example.com/image2.jpg',
//   //   'https://example.com/image3.jpg',
//   // ]; // Replace with your list of image URLs

//   @override
//   void initState() {
//     super.initState();
//     // _cacheAllImages();
//   }

//   Future<void> _cacheAllImages(imageUrls) async {
//     for (var imageUrl in imageUrls) {
//       try {
//         // Pre-cache the image using DefaultCacheManager
//         await DefaultCacheManager().getSingleFile(imageUrl);
//         print('Cached image: $imageUrl');
//       } catch (e) {
//         print('Failed to cache image: $imageUrl, Error: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Cache Images Example')),
//       body: Center(child: Text('Images are being cached in the background.')),
//     );
//   }
// }

// void main() => runApp(MaterialApp(home: CacheImagesApp()));
