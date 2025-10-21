import express from "express";
import migrateRoutes from "./presentation/routes/migrateRoutes";
import listEndpoints from "express-list-endpoints";

const app = express();
app.use(express.json());
app.use("/api", migrateRoutes);

setTimeout(() => {
  console.log("🧭 Available routes:");
  console.table(listEndpoints(app));
}, 1000);

export default app;
