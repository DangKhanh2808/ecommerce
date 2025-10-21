    import sql from "mssql";
    import dotenv from "dotenv";

    dotenv.config();

    const sqlConfig: sql.config = {
    user: process.env.DB_USER || "",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "",
    server: process.env.DB_SERVER || "localhost",
    port: Number(process.env.DB_PORT) || 1433,
    options: {
        encrypt: false, // true nếu dùng Azure
        trustServerCertificate: true,
    },
    };

    let poolPromise: Promise<sql.ConnectionPool> | null = null;

    // 👉 Hàm connect chỉ chạy 1 lần duy nhất
    export const sqlService = {
    connect: async (): Promise<sql.ConnectionPool> => {
        if (!poolPromise) {
        console.log("⏳ Connecting to MSSQL...");
        poolPromise = new sql.ConnectionPool(sqlConfig)
            .connect()
            .then((pool) => {
            console.log("✅ MSSQL Connected");
            return pool;
            })
            .catch((err) => {
            console.error("❌ MSSQL Connection Failed:", err);
            poolPromise = null; // reset nếu lỗi
            throw err;
            });
        }
        return poolPromise;
    },

    // 👉 Gọi query linh hoạt
    query: async (queryString: string, params?: Record<string, any>) => {
        const pool = await sqlService.connect();
        const request = pool.request();

        if (params) {
        Object.entries(params).forEach(([key, value]) => {
            request.input(key, value);
        });
        }

        return request.query(queryString);
    },
    };
