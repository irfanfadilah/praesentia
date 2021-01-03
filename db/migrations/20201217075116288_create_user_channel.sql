-- +micrate Up
CREATE TABLE user_channels (
  id BIGSERIAL PRIMARY KEY,
  user_id VARCHAR,
  channel_id VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS user_channels;
