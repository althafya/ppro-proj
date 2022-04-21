CREATE DATABASE ppro;

CREATE TABLE people (
    id BIGSERIAL,
    fullname TEXT,
    gender TEXT,
    phone TEXT,
    age INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);