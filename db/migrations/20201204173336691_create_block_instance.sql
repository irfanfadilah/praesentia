-- +micrate Up
CREATE TABLE block_instances (
  id BIGSERIAL PRIMARY KEY,
  channel_id VARCHAR UNIQUE,
  timestamp VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS block_instances;
