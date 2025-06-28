// core/utils/book_form_utils.dart
import 'dart:io';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookFormUtils {
  static final picker = ImagePicker();

  /// Ouvre la galerie et sélectionne une image valide
  static Future<dynamic> pickImageFromGallery(BuildContext context) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final ext = picked.name.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png'].contains(ext)) {
        if (kIsWeb) {
          final bytes = await picked.readAsBytes(); // ✅ pour le web
          return bytes; // type: Uint8List
        } else {
          return io.File(picked.path); // ✅ pour mobile
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner une image valide.')),
        );
      }
    }
    return null;
  }
  static void logFormValues({
    required String? titre,
    required String? auteur,
    required String? editeur,
    required String? classe,
    required String systeme,
    required bool bonEtat,
    required bool disponible,
    required List<String> matieres,
    required File? image,
  }) {
    print({
      'titre': titre,
      'auteur': auteur,
      'editeur': editeur,
      'classe': classe,
      'systeme': systeme,
      'état': bonEtat ? 'bon' : 'mauvais',
      'statut': disponible ? 'disponible' : 'vendu',
      'matières': matieres,
      'image': image?.path,
    });
  }
}
