CREATE OR REPLACE FUNCTION student_exam_tests(p_student_id INTEGER)
RETURNS TABLE (
    id INTEGER,
    student VARCHAR(255),
    teacher VARCHAR(255),
    subject_name VARCHAR(255),
    semester INTEGER,
    passed BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT et.id, u.full_name AS student, t.full_name AS teacher, s.subject_name, et.semester, et.passed
    FROM exam_tests et
    JOIN users u ON et.student_id = u.id
    JOIN teachers t ON et.teacher_id = t.id
    JOIN subjects s ON et.subject_id = s.id
    WHERE u.id = p_student_id;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION student_session_grades(p_student_id INTEGER)
RETURNS TABLE (
    id INTEGER,
    student VARCHAR(255),
    subject_name VARCHAR(255),
    teacher VARCHAR(255),
    semester INTEGER,
    grade grade_enum
) AS $$
BEGIN
    RETURN QUERY
    SELECT sg.id, u.full_name AS student, s.subject_name, t.full_name AS teacher, sg.semester, sg.grade
    FROM session_grades sg
    JOIN users u ON sg.student_id = u.id
    JOIN subjects s ON sg.subject_id = s.id
    JOIN teachers t ON sg.teacher_id = t.id
    WHERE u.id = p_student_id;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION student_debts(p_student_id INTEGER)
RETURNS TABLE (
    student VARCHAR(255),
    subject_name VARCHAR(255),
    semester INTEGER,
    exam_test_debt VARCHAR(10),
    session_debt VARCHAR(7)
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.full_name AS student, s.subject_name, et.semester,
           CASE
               WHEN et.passed IS NULL OR et.passed = false THEN 'exam_test'
               ELSE NULL
           END AS exam_test_debt,
           CASE
               WHEN sg.grade = 'неуд' THEN 'session'
               ELSE NULL
           END AS session_debt
    FROM users u
    JOIN exam_tests et ON u.id = et.student_id
    JOIN session_grades sg ON u.id = sg.student_id
    JOIN subjects s ON et.subject_id = s.id AND sg.subject_id = s.id
    WHERE (et.passed IS NULL OR et.passed = false) OR sg.grade = 'неуд'
    AND u.id = p_student_id;
END; $$ LANGUAGE plpgsql;


-- Create User
CREATE OR REPLACE PROCEDURE create_user(p_username VARCHAR(255), p_password VARCHAR(255), p_full_name VARCHAR(255), p_group_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO users (username, password, full_name, group_id)
  VALUES (p_username, p_password, p_full_name, p_group_id);
END;
$$;

-- Update User
CREATE OR REPLACE PROCEDURE update_user(p_id INTEGER, p_username VARCHAR(255), p_password VARCHAR(255), p_full_name VARCHAR(255), p_group_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE users
  SET username = p_username, password = p_password, full_name = p_full_name, group_id = p_group_id
  WHERE id = p_id;
END;
$$;

-- Create Group
CREATE OR REPLACE PROCEDURE create_group(p_group_name VARCHAR(255))
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO groups (group_name)
  VALUES (p_group_name);
END;
$$;

-- Update Group
CREATE OR REPLACE PROCEDURE update_group(p_id INTEGER, p_group_name VARCHAR(255))
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE groups
  SET group_name = p_group_name
  WHERE id = p_id;
END;
$$;

-- Create Subject
CREATE OR REPLACE PROCEDURE create_subject(p_subject_name VARCHAR(255))
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO subjects (subject_name)
  VALUES (p_subject_name);
END;
$$;

-- Update Subject
CREATE OR REPLACE PROCEDURE update_subject(p_id INTEGER, p_subject_name VARCHAR(255))
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE subjects
  SET subject_name = p_subject_name
  WHERE id = p_id;
END;
$$;

-- Create Teacher
CREATE OR REPLACE PROCEDURE create_teacher(p_full_name VARCHAR(255))
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO teachers (full_name)
  VALUES (p_full_name);
END;
$$;

-- Update Teacher
CREATE OR REPLACE PROCEDURE update_teacher(p_id INTEGER, p_full_name VARCHAR(255))
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE teachers
  SET full_name = p_full_name
  WHERE id = p_id;
END;
$$;

-- Set Exam Test Result
CREATE OR REPLACE PROCEDURE set_exam_test_result(p_id INTEGER, p_passed BOOLEAN)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE exam_tests
  SET passed = p_passed
  WHERE id = p_id;
END;
$$;

-- Set Session Grade
CREATE OR REPLACE PROCEDURE set_session_grade(p_id INTEGER, p_grade grade_enum)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE session_grades
  SET grade = p_grade
  WHERE id = p_id;
END;
$$;


-- CREATE OR REPLACE FUNCTION update_user(p_token VARCHAR, p_user_id INTEGER, p_username VARCHAR, p_password VARCHAR, p_full_name VARCHAR, p_group_id INTEGER, p_is_admin BOOLEAN)
-- RETURNS VOID AS $$
-- DECLARE
--     v_admin_id INTEGER;
-- BEGIN
--     SELECT user_id INTO v_admin_id
--     FROM tokens
--     WHERE token = p_token;
--
--     IF v_admin_id IS NULL THEN
--         RAISE EXCEPTION 'Доступ запрещен: недействительный токен.';
--     END IF;
--
--     UPDATE users
--     SET username = COALESCE(p_username, username),
--         password = COALESCE(p_password, password),
--         full_name = COALESCE(p_full_name, full_name),
--         group_id = COALESCE(p_group_id, group_id),
--         is_admin = COALESCE(p_is_admin, is_admin)
--     WHERE id = p_user_id;
--
--     IF p_is_admin THEN
--         PERFORM create_admin_token(p_user_id);
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- --SELECT update_user('your_token', user_id_to_update, p_group_id := group_id_to_set);
--
--
-- CREATE OR REPLACE FUNCTION login(p_username VARCHAR, p_password VARCHAR)
-- RETURNS TABLE(user_id INTEGER, username VARCHAR, full_name VARCHAR, admin_token VARCHAR) AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT u.id, u.username, u.full_name, t.token
--     FROM users u
--     LEFT JOIN tokens t ON u.id = t.user_id
--     WHERE u.username = p_username AND u.password = p_password;
-- END;
-- $$ LANGUAGE plpgsql;
--
--
-- CREATE OR REPLACE FUNCTION create_group(p_token VARCHAR, p_group_name VARCHAR)
-- RETURNS VOID AS $$
-- DECLARE
--     v_admin_id INTEGER;
-- BEGIN
--     SELECT user_id INTO v_admin_id
--     FROM tokens
--     WHERE token = p_token;
--
--     IF v_admin_id IS NULL THEN
--         RAISE EXCEPTION 'Доступ запрещен: недействительный токен.';
--     END IF;
--
--     INSERT INTO groups (group_name)
--     VALUES (p_group_name);
-- END;
-- $$ LANGUAGE plpgsql;
--
--
--
-- CREATE OR REPLACE FUNCTION create_teacher(p_token VARCHAR, p_full_name VARCHAR)
-- RETURNS VOID AS $$
-- DECLARE
--     v_admin_id INTEGER;
-- BEGIN
--     SELECT user_id INTO v_admin_id
--     FROM tokens
--     WHERE token = p_token;
--
--     IF v_admin_id IS NULL THEN
--         RAISE EXCEPTION 'Доступ запрещен: недействительный токен.';
--     END IF;
--
--     INSERT INTO teachers (full_name)
--     VALUES (p_full_name);
-- END;
-- $$ LANGUAGE plpgsql;
--
--
--
-- CREATE OR REPLACE FUNCTION create_subject(p_token VARCHAR, p_subject_name VARCHAR, p_hours INTEGER)
-- RETURNS VOID AS $$
-- DECLARE
--     v_admin_id INTEGER;
-- BEGIN
--     SELECT user_id INTO v_admin_id
--     FROM tokens
--     WHERE token = p_token;
--
--     IF v_admin_id IS NULL THEN
--         RAISE EXCEPTION 'Доступ запрещен: недействительный токен.';
--     END IF;
--
--     INSERT INTO subjects (subject_name, hours)
--     VALUES (p_subject_name, p_hours);
-- END;
-- $$ LANGUAGE plpgsql;
--
--
--
-- CREATE OR REPLACE FUNCTION set_class_grade(p_token VARCHAR, p_student_id INTEGER, p_teacher_id INTEGER, p_subject_id INTEGER, p_grade grade_enum, p_class_hour INTEGER)
-- RETURNS VOID AS $$
-- DECLARE
--     v_admin_id INTEGER;
-- BEGIN
--     SELECT user_id INTO v_admin_id
--     FROM tokens
--     WHERE token = p_token;
--
--     IF v_admin_id IS NULL THEN
--         RAISE EXCEPTION 'Доступ запрещен: недействительный токен.';
--     END IF;
--
--     IF EXISTS (SELECT 1 FROM class_grades WHERE student_id = p_student_id AND teacher_id = p_teacher_id AND subject_id = p_subject_id AND class_hour = p_class_hour) THEN
--         UPDATE class_grades
--         SET grade = COALESCE(p_grade, grade)
--         WHERE student_id = p_student_id AND teacher_id = p_teacher_id AND subject_id = p_subject_id AND class_hour = p_class_hour;
--     ELSE
--         INSERT INTO class_grades (student_id, teacher_id, subject_id, grade, class_hour)
--         VALUES (p_student_id, p_teacher_id, p_subject_id, p_grade, p_class_hour);
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;
--
--
-- CREATE OR REPLACE FUNCTION set_session_grade(p_token VARCHAR, p_student_id INTEGER, p_subject_id INTEGER, p_session_number INTEGER, p_grade grade_enum)
-- RETURNS VOID AS $$
-- DECLARE
--     v_admin_id INTEGER;
-- BEGIN
--     SELECT user_id INTO v_admin_id
--     FROM tokens
--     WHERE token = p_token;
--
--     IF v_admin_id IS NULL THEN
--         RAISE EXCEPTION 'Доступ запрещен: недействительный токен.';
--     END IF;
--
--     IF EXISTS (SELECT 1 FROM session_grades WHERE student_id = p_student_id AND subject_id = p_subject_id AND session_number = p_session_number) THEN
--         UPDATE session_grades
--         SET grade = COALESCE(p_grade, grade)
--         WHERE student_id = p_student_id AND subject_id = p_subject_id AND session_number = p_session_number;
--     ELSE
--         INSERT INTO session_grades (student_id, subject_id, session_number, grade)
--         VALUES (p_student_id, p_subject_id, p_session_number, p_grade);
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- -----------------------
--
-- CREATE OR REPLACE FUNCTION create_user(p_username VARCHAR, p_password VARCHAR, p_full_name VARCHAR, p_group_id INTEGER DEFAULT NULL)
-- RETURNS VOID AS $$
-- BEGIN
--     INSERT INTO users (username, password, full_name, group_id)
--     VALUES (p_username, p_password, p_full_name, p_group_id);
-- END;
-- $$ LANGUAGE plpgsql;
--
--
-- CREATE OR REPLACE FUNCTION get_debts(p_student_id INTEGER)
-- RETURNS TABLE(subject_id INTEGER, session_number INTEGER, grade grade_enum) AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT subject_id, session_number, grade
--     FROM session_grades
--     WHERE student_id = p_student_id AND grade = 'неуд';
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE OR REPLACE FUNCTION get_session_grades(p_student_id INTEGER, p_subject_id INTEGER)
-- RETURNS TABLE(student_id INTEGER, subject_id INTEGER, session_number INTEGER, grade grade_enum) AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT student_id, subject_id, session_number, grade
--     FROM session_grades
--     WHERE student_id = p_student_id AND subject_id = p_subject_id;
-- END;
-- $$ LANGUAGE plpgsql;
--
--
-- CREATE OR REPLACE FUNCTION get_class_grades(p_student_id INTEGER, p_subject_id INTEGER)
-- RETURNS TABLE(student_id INTEGER, teacher_id INTEGER, subject_id INTEGER, grade grade_enum, class_hour INTEGER) AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT student_id, teacher_id, subject_id, grade, class_hour
--     FROM class_grades
--     WHERE student_id = p_student_id AND subject_id = p_subject_id;
-- END;
-- $$ LANGUAGE plpgsql;
--
--
--
