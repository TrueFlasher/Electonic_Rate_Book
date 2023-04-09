GRANT ALL PRIVILEGES ON DATABASE mydb TO postgres;

-- Таблицы
CREATE TYPE grade_enum AS ENUM ('неуд', 'уд', 'хор', 'отл');

CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    group_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    group_id INTEGER DEFAULT NULL,
    FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
);

-- admin user 
INSERT INTO users (username, password, full_name) VALUES ('admin', 'admin', 'Администратор');


CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL
);

CREATE TABLE subjects (
    id SERIAL PRIMARY KEY,
    subject_name VARCHAR(255) NOT NULL
);

CREATE TABLE exam_tests (
    id SERIAL PRIMARY KEY,
    student_id INTEGER,
    teacher_id INTEGER,
    subject_id INTEGER,
    semester INTEGER NOT NULL,
    passed BOOLEAN DEFAULT NULL,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

CREATE TABLE session_grades (
    id SERIAL PRIMARY KEY,
    student_id INTEGER,
    subject_id INTEGER,
    teacher_id INTEGER,
    semester INTEGER NOT NULL,
    grade grade_enum NOT NULL,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE
);
