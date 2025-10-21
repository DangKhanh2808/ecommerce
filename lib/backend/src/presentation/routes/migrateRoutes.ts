import { Router } from "express";
import { MigrateProductsUseCase } from "../../application/usecases/MigrateProductsUseCase";
import { FirestoreProductRepository } from "../../infrastructure/firestore/FirestoreProductRepository";
import { MSSQLProductRepository } from "../../infrastructure/mssql/MSSQLProductRepository";

const router = Router();
console.log("✅ migrateRoutes.ts loaded!");

router.get("/migrate-products", async (req, res) => {
    try {
        const sourceRepo = new FirestoreProductRepository();
        const targetRepo = new MSSQLProductRepository();
        const useCase = new MigrateProductsUseCase(sourceRepo, targetRepo);

        await useCase.execute();

        res.status(200).json({ message: "✅ Products migrated successfully!" });
    } catch (error: any) {
        console.error("❌ Migration error:", error);
        res.status(500).json({
            error: "Migration failed",
            details: error?.message || error,
            stack: error?.stack,
        });
    }
});


export default router;
