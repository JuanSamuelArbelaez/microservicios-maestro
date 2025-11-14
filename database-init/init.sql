-- Crear el ENUM para el estado de cuenta
CREATE TYPE account_status_enum AS ENUM ('PENDING_VALIDATION', 'DELETED', 'VERIFIED');

CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(150) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       phone VARCHAR(20), -- nuevo campo
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       account_status account_status_enum NOT NULL DEFAULT 'PENDING_VALIDATION'
);

/*
-- Insertar datos de ejemplo
INSERT INTO users (name, email, password, account_status)
VALUES
    ('Anderson Peña', 'anderson@example.com', 'hashed_password_123', 'CREATED'),
    ('Maria Lopez', 'maria@example.com', 'hashed_password_456', 'CREATED');
*/

CREATE TYPE otp_status_enum AS ENUM ('CREATED', 'VERIFIED', 'EXPIRED');

CREATE TABLE otp (
    id SERIAL PRIMARY KEY,
    otp INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    otp_status otp_status_enum NOT NULL DEFAULT 'CREATED',
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    personal_url VARCHAR(500),
    nickname VARCHAR(100),
    is_contact_public BOOLEAN NOT NULL DEFAULT false,
    mailing_address TEXT,
    biography TEXT,
    organization VARCHAR(200),
    country VARCHAR(100),
    social_links JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_profile_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);