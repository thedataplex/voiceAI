CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE login (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

