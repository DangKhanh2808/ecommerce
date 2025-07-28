import 'package:flutter/material.dart';
import '../../../domain/order/entities/address.dart';

class AddressFormPage extends StatefulWidget {
  final Address? address;
  final String userId;
  final void Function(Address) onSave;

  const AddressFormPage({
    super.key,
    this.address,
    required this.userId,
    required this.onSave,
  });

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressLineController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name ?? '');
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _addressLineController = TextEditingController(text: widget.address?.addressLine ?? '');
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressLineController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: widget.address?.id ?? '',
        userId: widget.userId,
        name: _nameController.text,
        phone: _phoneController.text,
        addressLine: _addressLineController.text,
        isDefault: _isDefault,
      );
      widget.onSave(address);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipient Name'),
                validator: (v) => v == null || v.isEmpty ? 'Please enter recipient name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (v) => v == null || v.isEmpty ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressLineController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (v) => v == null || v.isEmpty ? 'Please enter address' : null,
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v ?? false),
                title: const Text('Set as default address'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.address == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 