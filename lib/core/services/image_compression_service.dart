import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for compressing images to reduce file size
class ImageCompressionService {
  /// Compress an image file
  /// 
  /// [imageFile] - The original image file to compress
  /// [quality] - Compression quality (0-100), default is 85
  /// [maxWidth] - Maximum width in pixels, default is 1920
  /// [maxHeight] - Maximum height in pixels, default is 1920
  /// [minWidth] - Minimum width in pixels, default is 0 (no minimum)
  /// [minHeight] - Minimum height in pixels, default is 0 (no minimum)
  /// 
  /// Returns the compressed image file, or null if compression fails
  Future<File?> compressImage({
    required File imageFile,
    int quality = 85,
    int maxWidth = 1920,
    int maxHeight = 1920,
    int minWidth = 0,
    int minHeight = 0,
  }) async {
    try {
      // Check if file exists
      if (!await imageFile.exists()) {
        return null;
      }

      // Get the file size before compression
      final originalSize = await imageFile.length();
      
      // Get temporary directory for compressed image
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = path.basenameWithoutExtension(imageFile.path);
      final fileExtension = path.extension(imageFile.path);
      final targetPath = path.join(
        tempDir.path,
        '${fileName}_compressed_$timestamp$fileExtension',
      );

      // Compress the image
      // Note: flutter_image_compress uses minWidth/minHeight for resizing
      // If maxWidth/maxHeight are specified, we'll use minWidth/minHeight to limit size
      final actualMinWidth = maxWidth > 0 ? maxWidth : (minWidth > 0 ? minWidth : 0);
      final actualMinHeight = maxHeight > 0 ? maxHeight : (minHeight > 0 ? minHeight : 0);
      
      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: quality,
        minWidth: actualMinWidth,
        minHeight: actualMinHeight,
        format: _getImageFormat(fileExtension),
      );

      if (compressedXFile == null) {
        return null;
      }

      // Convert XFile to File
      final compressedFile = File(compressedXFile.path);

      // Get the file size after compression
      final compressedSize = await compressedFile.length();
      
      // If compressed file is larger than original, return original
      if (compressedSize >= originalSize) {
        await compressedFile.delete();
        return imageFile;
      }

      return compressedFile;
    } catch (e) {
      // If compression fails, return original file
      return imageFile;
    }
  }

  /// Compress an image file with aggressive settings for maximum size reduction
  /// 
  /// [imageFile] - The original image file to compress
  /// 
  /// Returns the compressed image file, or null if compression fails
  Future<File?> compressImageAggressive(File imageFile) async {
    return compressImage(
      imageFile: imageFile,
      quality: 70,
      maxWidth: 1280,
      maxHeight: 1280,
    );
  }

  /// Compress an image file with moderate settings (balanced quality and size)
  /// 
  /// [imageFile] - The original image file to compress
  /// 
  /// Returns the compressed image file, or null if compression fails
  Future<File?> compressImageModerate(File imageFile) async {
    return compressImage(
      imageFile: imageFile,
      quality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
  }

  /// Compress an image file with light settings (high quality, minimal compression)
  /// 
  /// [imageFile] - The original image file to compress
  /// 
  /// Returns the compressed image file, or null if compression fails
  Future<File?> compressImageLight(File imageFile) async {
    return compressImage(
      imageFile: imageFile,
      quality: 95,
      maxWidth: 2560,
      maxHeight: 2560,
    );
  }

  /// Get the image format based on file extension
  CompressFormat _getImageFormat(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return CompressFormat.jpeg;
      case '.png':
        return CompressFormat.png;
      case '.heic':
        return CompressFormat.heic;
      case '.webp':
        return CompressFormat.webp;
      default:
        return CompressFormat.jpeg;
    }
  }

  /// Get file size in a human-readable format
  Future<String> getFileSize(File file) async {
    try {
      final size = await file.length();
      if (size < 1024) {
        return '${size}B';
      } else if (size < 1024 * 1024) {
        return '${(size / 1024).toStringAsFixed(2)}KB';
      } else {
        return '${(size / (1024 * 1024)).toStringAsFixed(2)}MB';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Compress multiple images
  /// 
  /// [imageFiles] - List of image files to compress
  /// [quality] - Compression quality (0-100)
  /// [maxWidth] - Maximum width in pixels
  /// [maxHeight] - Maximum height in pixels
  /// 
  /// Returns a list of compressed image files
  Future<List<File?>> compressImages({
    required List<File> imageFiles,
    int quality = 85,
    int maxWidth = 1920,
    int maxHeight = 1920,
  }) async {
    final results = <File?>[];
    for (final imageFile in imageFiles) {
      final compressed = await compressImage(
        imageFile: imageFile,
        quality: quality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      results.add(compressed);
    }
    return results;
  }
}

