-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
alter table activities
add column time_offset varchar;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
alter table activities
drop column time_offset;
