-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
alter table activities add column user_id varchar not null;
alter table activities add unique(user_id);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
alter table activities drop column user_id;
