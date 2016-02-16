CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(255),
  last_name VARCHAR(255)
);

CREATE TABLE orders(
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(255) NOT NULL,
  user_id bigint references users(id) NOT NULL
);
