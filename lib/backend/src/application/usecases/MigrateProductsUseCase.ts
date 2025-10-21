import { IProductRepository } from "../../domain/repositories/IProductRepository";
import { Product } from "../../domain/entities/Products";

export class MigrateProductsUseCase {
  private sourceRepo: IProductRepository;
  private targetRepo: IProductRepository;

  constructor(sourceRepo: IProductRepository, targetRepo: IProductRepository) {
    this.sourceRepo = sourceRepo;
    this.targetRepo = targetRepo;
  }

  async execute(): Promise<void> {
    console.log("🚀 Starting migration...");

    // 1️⃣ Lấy tất cả sản phẩm từ Firestore
    const products: Product[] = await this.sourceRepo.getAll();
    console.log(`📦 Retrieved ${products.length} products from Firestore.`);

    // 2️⃣ Lưu từng sản phẩm vào MSSQL
    for (const product of products) {
      await this.targetRepo.save(product);
    }

    console.log("✅ Migration completed successfully!");
  }
}
