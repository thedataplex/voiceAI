CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE login (
    id UUID PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

