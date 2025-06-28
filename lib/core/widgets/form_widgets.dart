import 'package:flutter/material.dart';

class FormWidgets {
  static Widget inputField(String hint, {void Function(String?)? onSaved}) {
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

  static Widget dropdownField({
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
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  static Widget checkboxField(
      String title, bool value, void Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: (val) => onChanged(val!),
    );
  }

  static Widget imagePlaceholder() {
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
}
