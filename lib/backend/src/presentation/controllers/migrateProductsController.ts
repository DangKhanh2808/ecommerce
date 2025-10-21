import { Router } from "express";
import { MigrateProductsUseCase } from "../../application/usecases/MigrateProductsUseCase";
import { MSSQLProductRepository } from "../../infrastructure/mssql/MSSQLProductRepository";
import { FirestoreProductRepository } from "../../infrastructure/firestore/FirestoreProductRepository";

const router = Router();

router.get("/migrate-products", async (req, res) => {
  try {
    const sourceRepo = new FirestoreProductRepository();
    const targetRepo = new MSSQLProductRepository();

    const migrateUseCase = new MigrateProductsUseCase(sourceRepo, targetRepo);

    await migrateUseCase.execute();

    res.status(200).json({ message: "✅ Products migrated successfully!" });
  } catch (error) {
    console.error("❌ Migration error:", error);
    res.status(500).json({ error: "Migration failed", details: error });
  }
});

export default router;
