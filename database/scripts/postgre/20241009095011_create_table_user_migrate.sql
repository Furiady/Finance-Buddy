-- Create table user
CREATE TABLE IF NOT EXISTS users (
    id bigserial PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ NULL,
    email VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    pin VARCHAR(255) NOT NULL,
    coin INT,
    balance BIGINT
);

-- Create table transaction
CREATE TABLE IF NOT EXISTS transactions (
    id bigserial PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(255) NOT NULL,
    value BIGINT NOT NULL,
    url VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ NULL
);

CREATE INDEX idx_transaction_user_id ON transactions(user_id, category);

-- Create table quest
CREATE TABLE IF NOT EXISTS quests (
    id bigserial PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    reward INT NOT NULL,
    cooldown INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE IF NOT EXISTS user_quest (
    user_id BIGINT REFERENCES users(id),
    quest_id BIGINT REFERENCES quests(id),
    status BOOLEAN NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, quest_id)
);

CREATE INDEX idx_user_quest_user_id ON user_quest(user_id);

-- Create table pet
CREATE TABLE IF NOT EXISTS pets (
    id bigserial PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    url VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS user_pet (
    user_id BIGINT REFERENCES users(id),
    pet_id BIGINT REFERENCES pets(id),
    status BOOLEAN NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, pet_id)
);

CREATE INDEX idx_user_pet_user_id ON user_pet(user_id);

-- Create table accessories
CREATE TABLE IF NOT EXISTS accessories (
    id bigserial PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    url VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS user_accessory (
    user_id BIGINT REFERENCES users(id),
    accessories_id BIGINT REFERENCES accessories(id),
    status BOOLEAN NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, accessories_id)
);

CREATE INDEX idx_user_accessory_user_id ON user_accessory(user_id);

-- Create table theme
CREATE TABLE IF NOT EXISTS themes (
    id bigserial PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    url VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS user_theme (
    user_id BIGINT REFERENCES users(id),
    theme_id BIGINT REFERENCES themes(id),
    status BOOLEAN NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, theme_id)
);

CREATE INDEX idx_user_theme_user_id ON user_theme(user_id);