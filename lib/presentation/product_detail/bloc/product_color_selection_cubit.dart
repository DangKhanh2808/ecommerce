import 'package:flutter_bloc/flutter_bloc.dart';

class ProductColorSelectionCubit extends Cubit<int> {
  ProductColorSelectionCubit() : super(0);

  int selectdIndex = 0;
  void itemSelection(int index) {
    selectdIndex = index;
    emit(
      index,
    );
  }
}
