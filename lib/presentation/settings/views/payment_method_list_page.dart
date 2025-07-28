import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/order/entities/payment_method.dart';
import '../bloc/payment_method_cubit.dart';
import '../../../service_locator.dart';
import 'payment_method_form_page.dart';

class PaymentMethodListPage extends StatelessWidget {
  final String userId;
  const PaymentMethodListPage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentMethodCubit(
        getMethods: sl(),
        addMethod: sl(),
        deleteMethod: sl(),
      )..loadMethods(userId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Manage Payment Methods'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentMethodFormPage(
                          userId: userId,
                          onSave: (method) {
                            context.read<PaymentMethodCubit>().addNewMethod(method, userId);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<PaymentMethodCubit, PaymentMethodState>(
              builder: (context, state) {
                if (state is PaymentMethodLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PaymentMethodLoaded) {
                  if (state.methods.isEmpty) {
                    return const Center(child: Text('No payment methods found.'));
                  }
                  return ListView.builder(
                    itemCount: state.methods.length,
                    itemBuilder: (context, index) {
                      final method = state.methods[index];
                      return ListTile(
                        title: Text('${method.type} - ****${method.last4Digits}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete',
                          onPressed: () {
                            context.read<PaymentMethodCubit>().deleteExistingMethod(method.id, userId);
                          },
                        ),
                      );
                    },
                  );
                }
                if (state is PaymentMethodError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
} 