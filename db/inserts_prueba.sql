USE honeycumb;

-- Insertar datos en la tabla `courses`
INSERT INTO courses (courseName, googleClassroomData) VALUES
('Mathematics 101', '{"classroomId": "abc123", "teacher": "Mr. Smith"}'),
('Physics 101', '{"classroomId": "def456", "teacher": "Dr. Brown"}'),
('Chemistry 101', '{"classroomId": "ghi789", "teacher": "Ms. Johnson"}'),
('Biology 101', '{"classroomId": "jkl012", "teacher": "Mr. Doe"}'),
('History 101', '{"classroomId": "mno345", "teacher": "Mr. Adams"}'),
('Literature 101', '{"classroomId": "pqr678", "teacher": "Ms. King"}'),
('Computer Science 101', '{"classroomId": "stu901", "teacher": "Ms. Hall"}');

-- Insertar datos en la tabla `students`
INSERT INTO students (names, lastNames, email, googleUserId, googleClassroomData) VALUES
('John', 'Doe', 'john.doe@example.com', 'g123456', '{"classroom": "Mathematics", "grade": 95}'),
('Jane', 'Doe', 'jane.doe@example.com', 'g654321', '{"classroom": "Physics", "grade": 89}'),
('Mike', 'Ross', 'mike.ross@example.com', 'g789123', '{"classroom": "Chemistry", "grade": 76}'),
('Rachel', 'Zane', 'rachel.zane@example.com', 'g321987', '{"classroom": "Biology", "grade": 88}'),
('Louis', 'Litt', 'louis.litt@example.com', 'g987654', '{"classroom": "History", "grade": 92}'),
('Harvey', 'Specter', 'harvey.specter@example.com', 'g852369', '{"classroom": "Literature", "grade": 80}'),
('Donna', 'Paulsen', 'donna.paulsen@example.com', 'g456789', '{"classroom": "Computer Science", "grade": 85}');

-- Insertar datos en la tabla `usuarios`
INSERT INTO usuarios (names, lastName, email, password_hash, googleUserId, userType) VALUES
('Admin', 'User', 'admin@example.com', 'password_hash_admin', 'g001', 'Administrador'),
('Coord', 'User', 'coord@example.com', 'password_hash_coord', 'g002', 'Coordinador'),
('Prof', 'Smith', 'smith@example.com', 'password_hash_prof', 'g003', 'Profesor'),
('Prof', 'Brown', 'brown@example.com', 'password_hash_brown', 'g004', 'Profesor'),
('Prof', 'Johnson', 'johnson@example.com', 'password_hash_johnson', 'g005', 'Profesor'),
('Prof', 'King', 'king@example.com', 'password_hash_king', 'g006', 'Profesor');

-- Insertar datos en la tabla `studentCourses`
INSERT INTO studentCourses (studentId, courseId, googleClassroomData) VALUES
(1, 1, '{"classroomId": "abc123", "grade": 95}'),
(1, 2, '{"classroomId": "def456", "grade": 89}'),
(2, 3, '{"classroomId": "ghi789", "grade": 76}'),
(2, 4, '{"classroomId": "jkl012", "grade": 88}'),
(3, 1, '{"classroomId": "abc123", "grade": 85}'),
(3, 5, '{"classroomId": "mno345", "grade": 92}'),
(4, 6, '{"classroomId": "pqr678", "grade": 80}'),
(5, 7, '{"classroomId": "stu901", "grade": 85}');

-- Insertar datos en la tabla `sessions`
INSERT INTO sessions (dateStart, dateExpiration, token, userIpAddress, userAgent, usuario) VALUES
(NOW(), NOW() + INTERVAL 1 HOUR, 'token1', '192.168.0.1', 'Mozilla/5.0', 1),
(NOW(), NOW() + INTERVAL 2 HOUR, 'token2', '192.168.0.2', 'Mozilla/5.0', 2),
(NOW(), NOW() + INTERVAL 3 HOUR, 'token3', '192.168.0.3', 'Mozilla/5.0', 3),
(NOW(), NOW() + INTERVAL 1 HOUR, 'token4', '192.168.0.4', 'Mozilla/5.0', 4),
(NOW(), NOW() + INTERVAL 2 HOUR, 'token5', '192.168.0.5', 'Mozilla/5.0', 5),
(NOW(), NOW() + INTERVAL 3 HOUR, 'token6', '192.168.0.6', 'Mozilla/5.0', 6);

-- Insertar datos en la tabla `userCourses`
INSERT INTO userCourses (course, user) VALUES
(1, 3),
(2, 4),
(3, 5),
(4, 6),
(5, 3),
(6, 4),
(7, 5);

-- Insertar datos en la tabla `registroAuditoria`
INSERT INTO registroAuditoria (tipoMovimiento, nombreUsuario, usuarioMovimiento, usuarioQueRealizoAccion, fechaMovimiento) VALUES
('UPDATE', 'Admin User', 'admin@example.com', 'admin@example.com', NOW()),
('UPDATE', 'Coord User', 'coord@example.com', 'admin@example.com', NOW()),
('DELETE', 'Prof Smith', 'smith@example.com', 'coord@example.com', NOW()),
('DELETE', 'Prof Brown', 'brown@example.com', 'coord@example.com', NOW()),
('UPDATE', 'Prof King', 'king@example.com', 'admin@example.com', NOW());
