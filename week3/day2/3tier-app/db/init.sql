CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO users (name, email)
VALUES
('Vibhav Khaneja', 'vibhav@example.com'),
('Sam Singh', 'sam@example.com');