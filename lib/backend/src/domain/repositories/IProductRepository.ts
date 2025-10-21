import { Product } from "../entities/Products";

export interface IProductRepository {
  getAll(): Promise<Product[]>;
  save(product: Product): Promise<void>;
}
