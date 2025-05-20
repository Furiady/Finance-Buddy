ALTER TABLE quests ADD COLUMN "limit" INTEGER;

ALTER TABLE user_quest ADD COLUMN count INTEGER;

INSERT INTO quests (id, title, description, reward, cooldown, created_at, deleted_at, "limit")
VALUES 
    (1, 'Login', 'Login into the app', 5, 1, NOW(), NULL, 1),
    (2, 'Create Transaction Record', 'Track your income & expense', 5, 1, NOW(), NULL, 3),
    (3, 'Use OCR', 'Use OCR to scan your receipt', 5, 1, NOW(), NULL, 1);