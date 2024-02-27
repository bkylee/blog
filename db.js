const { Pool } = require("pg");

const pool = new Pool({
  user: "postgres",
  host: "192.168.0.10",
  password: "",
  post: "5432",
});

module.exports = pool;
