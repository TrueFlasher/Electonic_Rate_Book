# -*- coding: utf-8 -*-
from flask import Flask, jsonify, request
import psycopg2



hostname="postgres_container"
database_name="mydb"
port = 5432
username="postgres"
password="postgres"

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False

def get_connection():
    return psycopg2.connect(f"postgresql://{username}:{password}@{hostname}:{port}/{database_name}")


@app.route("/groups", methods=["GET"])
def get_groups():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM groups_list")
            groups = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(groups)


@app.route("/subjects", methods=["GET"])
def get_subjects():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM subjects_list")
            subjects = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(subjects)


@app.route("/teachers", methods=["GET"])
def get_teachers():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM teachers_list")
            teachers = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(teachers)


@app.route("/exam_tests", methods=["GET"])
def get_exam_tests():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM exam_tests_list")
            exam_tests = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(exam_tests)


@app.route("/session_grades", methods=["GET"])
def get_session_grades():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM session_grades_list")
            session_grades = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(session_grades)


@app.route("/students/<int:group_id>", methods=["GET"])
def get_students_in_group(group_id):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM students_in_group WHERE group_id = %s", (group_id,))
            students = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(students)


@app.route("/student_exam_tests/<int:student_id>", methods=["GET"])
def get_student_exam_tests(student_id):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM student_exam_tests(%s)", (student_id,))
            student_exam_tests = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(student_exam_tests)


@app.route("/student_session_grades/<int:student_id>", methods=["GET"])
def get_student_session_grades(student_id):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM student_session_grades(%s)", (student_id,))
            student_session_grades = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(student_session_grades)


@app.route("/student_debts/<int:student_id>", methods=["GET"])
def get_student_debts(student_id):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM student_debts(%s)", (student_id,))
            student_debts = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
    return jsonify(student_debts)

# User routes
@app.route("/user", methods=["POST"])
def create_user():
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("create_user", (data["username"], data["password"], data["full_name"], data["group_id"]))
            conn.commit()
    return jsonify({"result": "User created successfully"}), 201

@app.route("/user/<int:user_id>", methods=["PUT"])
def update_user(user_id):
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("update_user", (user_id, data["username"], data["password"], data["full_name"], data["group_id"]))
            conn.commit()
    return jsonify({"result": "User updated successfully"}), 200

# Group routes
@app.route("/group", methods=["POST"])
def create_group():
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("create_group", (data["group_name"],))
            conn.commit()
    return jsonify({"result": "Group created successfully"}), 201

@app.route("/group/<int:group_id>", methods=["PUT"])
def update_group(group_id):
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("update_group", (group_id, data["group_name"]))
            conn.commit()
    return jsonify({"result": "Group updated successfully"}), 200

# Subject routes
@app.route("/subject", methods=["POST"])
def create_subject():
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("create_subject", (data["subject_name"],))
            conn.commit()
    return jsonify({"result": "Subject created successfully"}), 201

@app.route("/subject/<int:subject_id>", methods=["PUT"])
def update_subject(subject_id):
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("update_subject", (subject_id, data["subject_name"]))
            conn.commit()
    return jsonify({"result": "Subject updated successfully"}), 200

# Teacher routes
@app.route("/teacher", methods=["POST"])
def create_teacher():
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("create_teacher", (data["full_name"],))
            conn.commit()
    return jsonify({"result": "Teacher created successfully"}), 201

@app.route("/teacher/<int:teacher_id>", methods=["PUT"])
def update_teacher(teacher_id):
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("update_teacher", (teacher_id, data["full_name"]))
            conn.commit()
    return jsonify({"result": "Teacher updated successfully"}), 200

# Exam Test routes
@app.route("/exam_test/<int:exam_test_id>", methods=["PUT"])
def set_exam_test_result(exam_test_id):
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("set_exam_test_result", (exam_test_id, data["passed"]))
            conn.commit()
    return jsonify({"result": "Exam test result updated successfully"}), 200

# Session Grade routes
@app.route("/session_grade/<int:session_grade_id>", methods=["PUT"])
def set_session_grade(session_grade_id):
    data = request.get_json()
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.callproc("set_session_grade", (session_grade_id, data["grade"]))
            conn.commit()
    return jsonify({"result": "Session grade updated successfully"}), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
