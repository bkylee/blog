const express = require("express");
const router = express.Router();
const pool = require("./db");

router.get("api/get/allposts", (req, res, next) => {
  pool.query(
    `SELECT * FROM posts ORDER BY date_created DESC`,
    (q_err, q_res) => {
      res.json(q_res);
    }
  );
});

router.get("api/get/post", (req, res, next) => {
  const postid = req.query.post_id;

  pool.query(`SELECT * FROM posts WHERE pid=$1`, [postid], (q_err, q_res) => {
    res.json(q_res);
  });
});

router.post("api/post/posttodb", (req, res, next) => {
  const values = [req.body.title, req.body.body, req.body.uid];

  pool.query(
    `INSERT INTO posts (title, body, date_created) VALUES($1,$2,$3, NOW() )`,
    values,
    (q_err, q_res) => {
      if (q_err) return next(q_err);
      res.json(q_res);
    }
  );
});

router.put("api/put/post", (req, res, next) => {
  const values = [req.body.title, req.body.body, req.body.uid];

  pool.query(
    `UPDATE posts SET title=$1, body=$2, date_created=NOW() WHERE pid=$3`,
    values,
    (q_err, q_res) => {
      res.json(q_res);
    }
  );
});

router.delete("api/delete/post", (req, res, next) => {
  const postid = req.query.post_id;

  pool.query(
    `
    DELETE FROM posts WHERE pid=$1
    `,
    [postid],
    (q_err, q_res) => {
      res.json(q_res.rows);
      console.log(q_err);
    }
  );
});
