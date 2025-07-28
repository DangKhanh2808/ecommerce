import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/order/entities/address.dart';
import '../bloc/address_cubit.dart';
import '../../../service_locator.dart';
import 'address_form_page.dart';

class AddressListPage extends StatelessWidget {
  final String userId;
  const AddressListPage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressCubit(
        getAddresses: sl(),
        addAddress: sl(),
        updateAddress: sl(),
        deleteAddress: sl(),
      )..loadAddresses(userId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Manage Shipping Addresses'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddressFormPage(
                          userId: userId,
                          onSave: (address) {
                            context.read<AddressCubit>().addNewAddress(address, userId);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                if (state is AddressLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AddressLoaded) {
                  if (state.addresses.isEmpty) {
                    return const Center(child: Text('No addresses found.'));
                  }
                  return ListView.builder(
                    itemCount: state.addresses.length,
                    itemBuilder: (context, index) {
                      final address = state.addresses[index];
                      return ListTile(
                        title: Text(address.addressLine),
                        subtitle: Text('${address.name} - ${address.phone}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddressFormPage(
                                      userId: userId,
                                      address: address,
                                      onSave: (updated) {
                                        context.read<AddressCubit>().updateExistingAddress(
                                          updated.copyWith(id: address.id),
                                          userId,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete',
                              onPressed: () {
                                context.read<AddressCubit>().deleteExistingAddress(address.id, userId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is AddressError) {
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