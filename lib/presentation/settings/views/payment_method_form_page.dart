import 'package:flutter/material.dart';
import '../../../domain/order/entities/payment_method.dart';

class PaymentMethodFormPage extends StatefulWidget {
  final String userId;
  final void Function(PaymentMethod) onSave;

  const PaymentMethodFormPage({
    super.key,
    required this.userId,
    required this.onSave,
  });

  @override
  State<PaymentMethodFormPage> createState() => _PaymentMethodFormPageState();
}

class _PaymentMethodFormPageState extends State<PaymentMethodFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'card';
  final _last4Controller = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final method = PaymentMethod(
        id: '',
        userId: widget.userId,
        type: _type,
        last4Digits: _last4Controller.text,
        token: null,
      );
      widget.onSave(method);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment Method')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'card', child: Text('Credit Card')),
                  DropdownMenuItem(value: 'paypal', child: Text('PayPal')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'card'),
                decoration: const InputDecoration(labelText: 'Payment Type'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _last4Controller,
                decoration: const InputDecoration(labelText: 'Last 4 digits'),
                validator: (v) => v == null || v.length != 4 ? 'Please enter last 4 digits' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 