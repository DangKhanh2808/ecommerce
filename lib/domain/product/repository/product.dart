import 'package:dartz/dartz.dart';
import 'package:ecommerce/domain/product/entity/product.dart';

abstract class ProductRepository {
  Future<Either> getTopSelling();
  Future<Either> getNewIn();
  Future<Either> getProductsByCategoryId(String categoryId);
  Future<Either> getProductsByTitle(String title);
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product);
  Future<bool> isFavorite(String productId);
  Future<Either> getFavoritesProduct();
  Future<Either> createProduct(ProductEntity product);
  Future<Either> updateProduct(ProductEntity product);
  Future<Either> deleteProduct(String productId);
  Future<Either<String, List<ProductEntity>>> getRelatedProducts({required String categoryId, required String excludeProductId});
  Future<Either> getAllProducts();
}
