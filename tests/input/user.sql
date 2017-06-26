CREATE TABLE user (
    _id INTEGER NOT NULL PRIMARY KEY,
    name TEXT NULL DEFAULT '',
    surname TEXT NULL DEFAULT '',
    email TEXT NOT NULL,
    image TEXT NULL DEFAULT '',
    wizard_status INTEGER NOT NULL DEFAULT 0,
    color TEXT
)
