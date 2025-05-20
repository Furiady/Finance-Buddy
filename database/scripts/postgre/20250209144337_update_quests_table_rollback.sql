DELETE FROM quests WHERE id IN (1, 2, 3);

ALTER TABLE user_quest DROP COLUMN count;
ALTER TABLE quests DROP COLUMN limit;