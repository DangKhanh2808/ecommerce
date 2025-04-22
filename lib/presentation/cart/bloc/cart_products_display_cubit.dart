import 'package:ecommerce/domain/order/usecases/get_cart_products.dart';
import 'package:ecommerce/presentation/cart/bloc/cart_products_display_state.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartProductsDisplayCubit extends Cubit<CartProductsDisplayState> {
  CartProductsDisplayCubit() : super(CartProductsLoading());

  void displayCartProduct() async {
    var returnedData = await sl<GetCartProductsUseCase>().call();

    returnedData.fold((error) {
      emit(
        LoadCartProductsFailure(),
      );
    }, (data) {
      emit(
        CartProductsLoaded(
          products: data,
        ),
      );
    });
  }
}
