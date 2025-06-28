import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/education_constants.dart';
import '../../../core/utils/add_book_form_utils.dart';

class AddBooksPage extends StatefulWidget {
  const AddBooksPage({Key? key}) : super(key: key);

  @override
  State<AddBooksPage> createState() => _AddBooksPageState();
}

class _AddBooksPageState extends State<AddBooksPage> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String? _titre, _auteur, _editeur, _classe;
  String _systeme = 'Primaire';
  bool _bonEtat = false, _disponible = false;
  final List<String> _matieres = [];

  @override
  Widget build(BuildContext context) {
    final classes = _systeme == 'Primaire' ? classesPrimaire : classesSecondaire;

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
                  onTap: () async {
                    final pickedImage = await BookFormUtils.pickImageFromGallery(context);
                    if (pickedImage != null) {
                      setState(() => _image = pickedImage);
                    }
                  },
                  child: _image == null
                      ? _buildImagePlaceholder()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, height: 150),
                        ),
                ),

                const SizedBox(height: 20),
                _buildInput('Titre', onSaved: (val) => _titre = val),
                _buildInput('Auteur', onSaved: (val) => _auteur = val),
                _buildInput('Éditeur', onSaved: (val) => _editeur = val),

                _buildDropdown(
                  label: 'Système éducatif',
                  value: _systeme,
                  items: ['Primaire', 'Secondaire'],
                  onChanged: (val) => setState(() {
                    _systeme = val!;
                    _classe = null;
                  }),
                ),

                _buildDropdown(
                  label: 'Classe',
                  value: _classe,
                  items: classes,
                  onChanged: (val) => setState(() => _classe = val),
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Matières", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Wrap(
                  spacing: 8,
                  children: matieres.map((matiere) {
                    return FilterChip(
                      label: Text(matiere),
                      selected: _matieres.contains(matiere),
                      onSelected: (selected) {
                        setState(() {
                          selected ? _matieres.add(matiere) : _matieres.remove(matiere);
                        });
                      },
                    );
                  }).toList(),
                ),

                _buildCheckbox('Bon état', _bonEtat, (val) => setState(() => _bonEtat = val)),
                _buildCheckbox('Disponible', _disponible, (val) => setState(() => _disponible = val)),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _formKey.currentState?.save();
                    BookFormUtils.logFormValues(
                      titre: _titre,
                      auteur: _auteur,
                      editeur: _editeur,
                      classe: _classe,
                      systeme: _systeme,
                      bonEtat: _bonEtat,
                      disponible: _disponible,
                      matieres: _matieres,
                      image: _image,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Soumettre",
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

  Widget _buildCheckbox(String title, bool value, void Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: (val) => onChanged(val!),
    );
  }
}
