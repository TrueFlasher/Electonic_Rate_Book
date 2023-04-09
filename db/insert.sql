-- Groups
INSERT INTO groups (group_name) VALUES ('Group 1');
INSERT INTO groups (group_name) VALUES ('Group 2');
INSERT INTO groups (group_name) VALUES ('Group 3');

-- Users
INSERT INTO users (username, password, full_name, group_id) VALUES ('student1', 'password1', 'Student One', 1);
INSERT INTO users (username, password, full_name, group_id) VALUES ('student2', 'password2', 'Student Two', 1);
INSERT INTO users (username, password, full_name, group_id) VALUES ('student3', 'password3', 'Student Three', 2);
INSERT INTO users (username, password, full_name, group_id) VALUES ('student4', 'password4', 'Student Four', 2);
INSERT INTO users (username, password, full_name, group_id) VALUES ('student5', 'password5', 'Student Five', 3);

-- Teachers
INSERT INTO teachers (full_name) VALUES ('Teacher One');
INSERT INTO teachers (full_name) VALUES ('Teacher Two');
INSERT INTO teachers (full_name) VALUES ('Teacher Three');

-- Subjects
INSERT INTO subjects (subject_name) VALUES ('Subject 1');
INSERT INTO subjects (subject_name) VALUES ('Subject 2');
INSERT INTO subjects (subject_name) VALUES ('Subject 3');

-- Exam Tests
INSERT INTO exam_tests (student_id, teacher_id, subject_id, semester, passed) VALUES (1, 1, 1, 1, true);
INSERT INTO exam_tests (student_id, teacher_id, subject_id, semester, passed) VALUES (1, 1, 2, 1, false);
INSERT INTO exam_tests (student_id, teacher_id, subject_id, semester) VALUES (1, 1, 3, 1);
INSERT INTO exam_tests (student_id, teacher_id, subject_id, semester, passed) VALUES (2, 2, 1, 1, true);
INSERT INTO exam_tests (student_id, teacher_id, subject_id, semester, passed) VALUES (3, 3, 2, 1, false);
INSERT INTO exam_tests (student_id, teacher_id, subject_id, semester) VALUES (4, 1, 3, 1);

-- Session Grades
INSERT INTO session_grades (student_id, subject_id, teacher_id, semester, grade) VALUES (1, 1, 1, 1, 'отл');
INSERT INTO session_grades (student_id, subject_id, teacher_id, semester, grade) VALUES (1, 2, 1, 1, 'неуд');
INSERT INTO session_grades (student_id, subject_id, teacher_id, semester, grade) VALUES (1, 3, 1, 1, 'хор');
INSERT INTO session_grades (student_id, subject_id, teacher_id, semester, grade) VALUES (2, 1, 2, 1, 'уд');
INSERT INTO session_grades (student_id, subject_id, teacher_id, semester, grade) VALUES (3, 2, 3, 1, 'неуд');
INSERT INTO session_grades (student_id, subject_id, teacher_id, semester, grade) VALUES (4, 3, 1, 1, 'хор');

