import { IProductRepository } from "../../domain/repositories/IProductRepository";
import { Product } from "../../domain/entities/Products";
import { firestoreDB } from "../config/firestore";

export class FirestoreProductRepository implements IProductRepository {
  async getAll(): Promise<Product[]> {
    const snapshot = await firestoreDB.collection("Products").get();
    const products: Product[] = [];

    snapshot.forEach(doc => {
      const data = doc.data();

      products.push({
        productId: data.productId || doc.id,
        categoryId: data.categoryId || "",
        title: data.title || "",
        price: data.price || 0,
        discountedPrice: data.discountedPrice || 0,
        gender: data.gender || 0,
        salesNumber: data.salesNumber || 0,
        createdDate: data.createdDate
          ? (data.createdDate.toDate ? data.createdDate.toDate() : new Date(data.createdDate))
          : new Date(),

        colors: JSON.stringify(data.colors || []),
        images: JSON.stringify(data.images || []),
        sizes: JSON.stringify(data.sizes || []),
      });
    });

    return products;
  }

  async save(): Promise<void> {
    throw new Error("Save not implemented for Firestore");
  }
}
