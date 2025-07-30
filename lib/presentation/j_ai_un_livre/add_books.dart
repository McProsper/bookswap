import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/routes.dart';
import '../../services/api_service.dart';
import '../../../core/constants/education_constants.dart';

class AddBooksPage extends StatefulWidget {
  const AddBooksPage({Key? key}) : super(key: key);

  @override
  State<AddBooksPage> createState() => _AddBooksPageState();
}

class _AddBooksPageState extends State<AddBooksPage> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String? _title, _author, _level;
  String _condition = 'Neuf';  
  String _systeme = 'Primaire';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final classes = _systeme == 'Primaire' ? classesPrimaire : 
      _systeme == 'Collège' ? classesCollege : 
      _systeme == 'Autre' ? [''] : classesLycee;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Ajouter un Livre',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? _buildImagePlaceholder()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, height: 150),
                        ),
                ),
                const SizedBox(height: 20),
                _buildInput('Titre', onSaved: (val) => _title = val),
                _buildInput('Auteur', onSaved: (val) => _author = val),

                _buildDropdown(
                  label: 'Système éducatif',
                  value: _systeme,
                  items: ['Primaire', 'Collège', 'Lycée', 'Autre'],
                  onChanged: (val) => setState(() {
                    _systeme = val!;
                    _level = null;
                  }),                                                                                                                                             
                ),

                if(_systeme != 'Autre') _buildDropdown(
                  label: 'Classe',
                  value: _level,
                  items: classes,
                  onChanged: (val) => setState(() => _level = val),
                ),
                
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("État du livre", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Neuf',
                      groupValue: _condition,
                      onChanged: (value) {
                        setState(() {
                          _condition = value!;
                        });
                      },
                    ),
                    const Text('Neuf'),
                    Radio<String>(
                      value: 'Occasion',
                      groupValue: _condition,              
                      onChanged: (value) {
                        setState(() {
                          _condition = value!;
                        });
                      },
                    ),
                    const Text('Occasion'),
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                        onTap: () async {
                          _formKey.currentState?.save();
                          if (_image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Veuillez sélectionner une image')),
                            );
                            return;
                          }
                          setState(() => _isLoading = true);
                          try {
                            final imageUrl = await ApiService().uploadImage(_image!);
                            if (imageUrl == null) {
                              throw Exception('Échec de l’upload de l’image');
                            }
                            await ApiService().addBook(
                              title: _title ?? '',
                              author: _author ?? '',
                              systeme: _systeme,
                              level: _level ?? '',
                              condition: _condition,
                              imageUrl: imageUrl,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Livre ajouté avec succès !')),
                            );
                            setState(() {
                              _image = null;
                              _title = null;
                              _author = null;
                              _systeme = 'Primaire';
                              _level = null;
                              _condition = 'Neuf';
                            });
                            // sleep(const Duration(seconds: 3));
                            Navigator.pushReplacementNamed(context, AppRoutes.choice);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erreur: $e')),
                            );
                          }
                          setState(() => _isLoading = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Publier le livre",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('Sélectionner une image')),
    );
  }

  Widget _buildInput(String hint, {void Function(String?)? onSaved}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            onSaved: onSaved,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        value: value,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
