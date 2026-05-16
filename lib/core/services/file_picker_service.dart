import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

class FilePickerService {
  File? selectedImage;
  final _imagePicker = ImagePicker();
  final Logger log = Logger();

  Future<File?> pickImage() async {
    return await pickImageWithoutCompression();
  }

  Future<File?> pickImageWithCompression() async {
    File? selectedImage;
    final image50 = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    final image100 = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (image50 != null) selectedImage = File(image50.path);

    log.d('Image50 Size: ${await image50?.length()}');
    log.d('Image100 Size: ${await image100?.length()}');

    return selectedImage;
  }

  Future<File?> pickImageWithoutCompression() async {
    File? selectedImage;
    final _filePicker = FilePicker.platform;
    FilePickerResult? result = await _filePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      selectedImage = File(result.paths.first!);
      final extension = p.extension(selectedImage.path).toLowerCase();
      debugPrint('@FilePickerService.pickImage ==> Extension: $extension');

      // Convert HEIC to JPEG purely in Dart
      if (extension == '.heic') {
        selectedImage = await _convertHeicToJpeg(selectedImage);
      }

      // final newPath = '$dir/test.jpg';
      // final compressedImage = await _compressImageFile(selectedImage, newPath);
      // if (compressedImage != null) {
      //   selectedImage = compressedImage;
      // }
    }

    return selectedImage;
  }

  /// Converts a HEIC file to JPEG using Dart `image` package
  Future<File?> _convertHeicToJpeg(File heicFile) async {
    try {
      final bytes = await heicFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      final targetPath = heicFile.path.replaceAll('.heic', '.jpg');
      final jpegBytes = img.encodeJpg(image, quality: 100);
      final newFile = File(targetPath);
      await newFile.writeAsBytes(jpegBytes);
      debugPrint('HEIC converted to JPEG: $targetPath');
      return newFile;
    } catch (e) {
      debugPrint('Failed to convert HEIC: $e');
      return heicFile; // fallback to original if conversion fails
    }
  }

  // Future<File?> _compressImageFile(File file, String targetPath) async {
  //   debugPrint(
  //       '@compressImageFile => Size before compression: ${await file.length()}');
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 70,
  //   );

  //   if (result != null) {
  //     print('File compressed successfully');
  //   } else {
  //     print('Compressed file path is null');
  //   }

  //   debugPrint(
  //       '@compressImageFile => Size after compression: ${await result?.length()}');
  //   return result;
  // }
}
