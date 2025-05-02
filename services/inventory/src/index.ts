//express app

import express from "express";
import cors from "cors";
import morgan from "morgan";
import { z } from "zod";

// dotenv initialization
import dotenv from "dotenv";
dotenv.config();

const app = express();

app.use(cors());
app.use(morgan("dev"));
app.use(express.json());

app.get("/health", (_req, res) => {
  res.status(200).json({ status: "UP" });
});

// 404 handler
app.use((_req, res) => {
  res.status(404).json({ error: "not found" });
});

// 500 handler
app.use((err, _req, res, _next) => {
  console.error(err.stack);
  res.status(500).json({ error: "Internel server error" });
});

const port = process.env.PORT || 4002;
const serviceName = process.env.SERVICE_NAME || "inventory-service";
app.listen(port, () => {
  console.log(`Inventory service listening on port ${port}`);
});
