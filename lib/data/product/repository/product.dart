import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/product/models/product.dart';
import 'package:ecommerce/data/product/source/product_firebase_service.dart';
import 'package:ecommerce/domain/product/entity/product.dart';
import 'package:ecommerce/domain/product/repository/product.dart';
import 'package:ecommerce/service_locator.dart';

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<Either> getTopSelling() async {
    var returnedData = await sl<ProductFirebaseService>().getTopSelling();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return right(List.from(data)
            .map((doc) {
              if (doc is Map<String, dynamic>) {
                return ProductModel.fromMap(doc, doc['docId'] ?? '').toEntity();
              } else {
                return ProductModel.fromMap(doc.data(), doc.id).toEntity();
              }
            })
            .toList());
      },
    );
  }

  @override
  Future<Either> getNewIn() async {
    var returnedData = await sl<ProductFirebaseService>().getNewIn();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return right(List.from(data)
            .map((doc) {
              if (doc is Map<String, dynamic>) {
                return ProductModel.fromMap(doc, doc['docId'] ?? '').toEntity();
              } else {
                return ProductModel.fromMap(doc.data(), doc.id).toEntity();
              }
            })
            .toList());
      },
    );
  }

  @override
  Future<Either> getProductsByCategoryId(String categoryId) async {
    var returnedData = await sl<ProductFirebaseService>().getProductsByCategoryId(categoryId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        // data là List<QueryDocumentSnapshot>
        return right(List.from(data)
            .map((doc) {
              if (doc is Map<String, dynamic>) {
                return ProductModel.fromMap(doc, doc['docId'] ?? '').toEntity();
              } else {
                return ProductModel.fromMap(doc.data(), doc.id).toEntity();
              }
            })
            .toList());
      },
    );
  }

  @override
  Future<Either> getProductsByTitle(String title) async {
    var returnedData = await sl<ProductFirebaseService>().getProductsByTitle(title);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return right(List.from(data)
            .map((doc) {
              if (doc is Map<String, dynamic>) {
                return ProductModel.fromMap(doc, doc['docId'] ?? '').toEntity();
              } else {
                return ProductModel.fromMap(doc.data(), doc.id).toEntity();
              }
            })
            .toList());
      },
    );
  }

  @override
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product) async {
    var returnedData =
        await sl<ProductFirebaseService>().addOrRemoveFavoriteProduct(product);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return right(data);
      },
    );
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return await sl<ProductFirebaseService>().isFavorite(productId);
  }

  @override
  Future<Either> getFavoritesProduct() async {
    var returnedData = await sl<ProductFirebaseService>().getFavoritesProduct();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return right(List.from(data)
            .map((e) {
              if (e is Map<String, dynamic>) {
                return ProductModel.fromMap(e, e['docId'] ?? '').toEntity();
              } else {
                return ProductModel.fromMap(e.data(), e.id).toEntity();
              }
            })
            .toList());
      },
    );
  }

  @override
  Future<Either> createProduct(ProductEntity product) async {
    var returnedData =
        await sl<ProductFirebaseService>().createProduct(product);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return right(data);
      },
    );
  }

  @override
  Future<Either> deleteProduct(String productId) {
    return sl<ProductFirebaseService>().deleteProduct(productId).then(
          (value) => value.fold(
            (error) => Left(error),
            (data) => Right(data),
          ),
        );
  }

  @override
  Future<Either> updateProduct(ProductEntity product) {
    var returnedData = sl<ProductFirebaseService>().updateProduct(product);
    return returnedData.then(
      (value) => value.fold(
        (error) => Left(error),
        (data) => Right(data),
      ),
    );
  }

  @override
  Future<Either<String, List<ProductEntity>>> getRelatedProducts({required String categoryId, required String excludeProductId}) async {
    var returnedData = await sl<ProductFirebaseService>().getRelatedProducts(categoryId: categoryId, excludeProductId: excludeProductId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return right(List.from(data)
            .map((doc) {
              if (doc is Map<String, dynamic>) {
                return ProductModel.fromMap(doc, doc['docId'] ?? '').toEntity();
              } else {
                return ProductModel.fromMap(doc.data(), doc.id).toEntity();
              }
            })
            .toList());
      },
    );
  }

  @override
  Future<Either> getAllProducts() async {
    var returnedData = await sl<ProductFirebaseService>().getAllProducts();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return right(List.from(data)
            .map((doc) {
              if (doc is Map<String, dynamic>) {
                return ProductModel.fromMap(doc, doc['docId'] ?? '').toEntity();
              } else {
                return ProductModel.fromMap(doc.data(), doc.id).toEntity();
              }
            })
            .toList());
      },
    );
  }
}
