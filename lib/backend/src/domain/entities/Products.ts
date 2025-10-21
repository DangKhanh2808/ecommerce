export interface Product {
    productId: string;
    categoryId: string;
    title: string;
    price: number;
    discountedPrice: number;
    gender: number;
    salesNumber: number;
    createdDate: Date;
    colors: string; // lưu JSON string
    images: string; // lưu JSON string
    sizes: string;  // lưu JSON string
  }
  