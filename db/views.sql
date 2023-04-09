CREATE VIEW groups_list AS
SELECT id, group_name
FROM groups;

CREATE VIEW students_in_group AS
SELECT u.id, u.username, u.full_name, g.group_name
FROM users u
JOIN groups g ON u.group_id = g.id
WHERE u.group_id IS NOT NULL;


CREATE VIEW subjects_list AS
SELECT id, subject_name
FROM subjects;

CREATE VIEW teachers_list AS
SELECT id, full_name
FROM teachers;

CREATE VIEW exam_tests_list AS
SELECT et.id, u.full_name AS student, t.full_name AS teacher, s.subject_name, et.semester, et.passed
FROM exam_tests et
JOIN users u ON et.student_id = u.id
JOIN teachers t ON et.teacher_id = t.id
JOIN subjects s ON et.subject_id = s.id;


CREATE VIEW session_grades_list AS
SELECT sg.id, u.full_name AS student, s.subject_name, t.full_name AS teacher, sg.semester, sg.grade
FROM session_grades sg
JOIN users u ON sg.student_id = u.id
JOIN subjects s ON sg.subject_id = s.id
JOIN teachers t ON sg.teacher_id = t.id;










-- CREATE VIEW students_in_group AS
-- SELECT u.id, u.username, u.full_name, g.group_name
-- FROM users u
-- JOIN groups g ON u.group_id = g.id;
--
--
--
-- CREATE VIEW teachers_subjects_for_group AS
-- SELECT g.group_name, t.id AS teacher_id, t.full_name AS teacher_name, s.id AS subject_id, s.subject_name
-- FROM class_grades cg
-- JOIN users u ON cg.student_id = u.id
-- JOIN groups g ON u.group_id = g.id
-- JOIN teachers t ON cg.teacher_id = t.id
-- JOIN subjects s ON cg.subject_id = s.id
-- GROUP BY g.group_name, t.id, s.id;
--
--
-- CREATE VIEW group_grades_teacher_subject AS
-- SELECT g.group_name, u.id AS student_id, u.full_name AS student_name, t.id AS teacher_id, t.full_name AS teacher_name, s.id AS subject_id, s.subject_name, cg.grade
-- FROM class_grades cg
-- JOIN users u ON cg.student_id = u.id
-- JOIN groups g ON u.group_id = g.id
-- JOIN teachers t ON cg.teacher_id = t.id
-- JOIN subjects s ON cg.subject_id = s.id;
--
--
-- CREATE VIEW all_groups AS
-- SELECT * FROM groups;
--
--
-- CREATE VIEW all_teachers AS
-- SELECT * FROM teachers;
--
-- CREATE VIEW all_subjects AS
-- SELECT * FROM subjects;
--
--
-- CREATE VIEW subjects_by_teacher AS
-- SELECT t.id AS teacher_id, t.full_name AS teacher_name, s.id AS subject_id, s.subject_name
-- FROM class_grades cg
-- JOIN teachers t ON cg.teacher_id = t.id
-- JOIN subjects s ON cg.subject_id = s.id
-- GROUP BY t.id, s.id;
--
