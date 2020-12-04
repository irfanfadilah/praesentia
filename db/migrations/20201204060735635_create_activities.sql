-- +micrate Up
CREATE TABLE activities (
  id BIGSERIAL PRIMARY KEY,
  state VARCHAR,
  comment VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS activities;
