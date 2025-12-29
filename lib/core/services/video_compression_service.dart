import 'dart:io';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for compressing videos to reduce file size
class VideoCompressionService {
  /// Compress a video file
  /// 
  /// [videoFile] - The original video file to compress
  /// [quality] - Video quality (VideoQuality enum)
  /// [deleteOrigin] - Whether to delete the original file after compression
  /// 
  /// Returns the compressed video file, or null if compression fails
  Future<File?> compressVideo({
    required File videoFile,
    VideoQuality quality = VideoQuality.MediumQuality,
    bool deleteOrigin = false,
  }) async {
    try {
      // Check if file exists
      if (!await videoFile.exists()) {
        return null;
      }

      // Get the file size before compression
      final originalSize = await videoFile.length();
      
      // Compress the video
      final mediaInfo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: quality,
        deleteOrigin: deleteOrigin,
        includeAudio: true,
      );

      if (mediaInfo == null || mediaInfo.path == null) {
        return null;
      }

      final compressedFile = File(mediaInfo.path!);

      // Get the file size after compression
      final compressedSize = await compressedFile.length();
      
      // If compressed file is larger than original, return original
      if (compressedSize >= originalSize) {
        await compressedFile.delete();
        return videoFile;
      }

      return compressedFile;
    } catch (e) {
      // If compression fails, return original file
      return videoFile;
    }
  }

  /// Compress video optimized for upload (aggressive compression for faster uploads)
  /// This method ensures the video is under a target size (default 20MB)
  /// 
  /// [videoFile] - The video file to compress
  /// [maxSizeBytes] - Maximum file size in bytes (default 20MB)
  /// 
  /// Returns the compressed video file
  Future<File?> compressVideoForUpload(
    File videoFile, {
    int maxSizeBytes = 20 * 1024 * 1024, // 20MB default
  }) async {
    try {
      if (!await videoFile.exists()) {
        return null;
      }

      final currentSize = await videoFile.length();
      
      // If already under target size, return as-is
      if (currentSize <= maxSizeBytes) {
        return videoFile;
      }

      // Try medium quality first
      File? compressed = await compressVideo(
        videoFile: videoFile,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );
      
      if (compressed != null) {
        final compressedSize = await compressed.length();
        if (compressedSize <= maxSizeBytes) {
          return compressed;
        }
      }

      // If still too large, use low quality
      compressed = await compressVideo(
        videoFile: compressed ?? videoFile,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
      );

      if (compressed != null) {
        final compressedSize = await compressed.length();
        if (compressedSize <= maxSizeBytes) {
          return compressed;
        }
      }

      // If still too large, use default quality (most aggressive)
      compressed = await compressVideo(
        videoFile: compressed ?? videoFile,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
      );

      return compressed ?? videoFile;
    } catch (e) {
      return videoFile;
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

  /// Get file size in bytes
  Future<int> getFileSizeBytes(File file) async {
    try {
      return await file.length();
    } catch (e) {
      return 0;
    }
  }

  /// Check if file size is acceptable for upload
  /// 
  /// [file] - The file to check
  /// [maxSizeBytes] - Maximum acceptable size in bytes
  /// 
  /// Returns true if file size is acceptable
  Future<bool> isFileSizeAcceptable(
    File file, {
    int maxSizeBytes = 50 * 1024 * 1024, // 50MB default
  }) async {
    try {
      final size = await file.length();
      return size <= maxSizeBytes;
    } catch (e) {
      return false;
    }
  }

  /// Cancel any ongoing compression
  Future<void> cancelCompression() async {
    try {
      await VideoCompress.cancelCompression();
    } catch (e) {
      // Ignore errors
    }
  }

  /// Delete all cached compressed videos
  Future<void> deleteAllCache() async {
    try {
      await VideoCompress.deleteAllCache();
    } catch (e) {
      // Ignore errors
    }
  }
}

