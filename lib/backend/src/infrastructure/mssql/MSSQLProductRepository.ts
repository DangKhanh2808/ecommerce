import { IProductRepository } from "../../domain/repositories/IProductRepository";
import { Product } from "../../domain/entities/Products";
import sql from "mssql";
import { sqlService } from "../../infrastructure/config/mssql.js";

export class MSSQLProductRepository implements IProductRepository {
  async getAll(): Promise<Product[]> {
    const pool = await sqlService.connect();
    const result = await pool.request().query("SELECT * FROM Products");
    return result.recordset;
  }

  async save(product: Product): Promise<void> {
    const pool = await sqlService.connect();

    await pool
      .request()
      // 🧩 Thêm lại cột productId
      .input("productId", sql.NVarChar, product.productId)
      .input("CategoryId", sql.NVarChar, product.categoryId)
      .input("Title", sql.NVarChar, product.title)
      .input("Price", sql.Float, product.price)
      .input("DiscountedPrice", sql.Float, product.discountedPrice)
      .input("Gender", sql.Int, product.gender)
      .input("SalesNumber", sql.Int, product.salesNumber)
      .input(
        "CreatedDate",
        sql.DateTime,
        product.createdDate ? new Date(product.createdDate) : new Date()
      )
      .input("Colors", sql.NVarChar(sql.MAX), JSON.stringify(product.colors))
      .input("Images", sql.NVarChar(sql.MAX), JSON.stringify(product.images))
      .input("Sizes", sql.NVarChar(sql.MAX), JSON.stringify(product.sizes))
      .query(`
        INSERT INTO Products 
        (productId, CategoryId, Title, Price, DiscountedPrice, Gender, SalesNumber, CreatedDate, Colors, Images, Sizes)
        VALUES 
        (@productId, @CategoryId, @Title, @Price, @DiscountedPrice, @Gender, @SalesNumber, @CreatedDate, @Colors, @Images, @Sizes)
      `);
  }
}
