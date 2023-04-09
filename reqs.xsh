curl -X POST -H "Content-Type: application/json" -d '{"username": "john_doe", "password": "123456", "full_name": "John Doe", "group_id": 1}' http://localhost:5000/user
curl -X PUT -H "Content-Type: application/json" -d '{"username": "john_doe_updated", "password": "654321", "full_name": "John Doe Updated", "group_id": 2}' http://localhost:5000/user/1
curl -X POST -H "Content-Type: application/json" -d '{"group_name": "Group 1"}' http://localhost:5000/group
curl -X PUT -H "Content-Type: application/json" -d '{"group_name": "Group 1 Updated"}' http://localhost:5000/group/1
curl -X POST -H "Content-Type: application/json" -d '{"subject_name": "Mathematics"}' http://localhost:5000/subject
curl -X PUT -H "Content-Type: application/json" -d '{"subject_name": "Mathematics Advanced"}' http://localhost:5000/subject/1
curl -X POST -H "Content-Type: application/json" -d '{"full_name": "Jane Smith"}' http://localhost:5000/teacher
curl -X PUT -H "Content-Type: application/json" -d '{"full_name": "Jane Smith Updated"}' http://localhost:5000/teacher/1
curl -X PUT -H "Content-Type: application/json" -d '{"passed": true}' http://localhost:5000/exam_test/1
curl -X PUT -H "Content-Type: application/json" -d '{"grade": "отл"}' http://localhost:5000/session_grade/1

