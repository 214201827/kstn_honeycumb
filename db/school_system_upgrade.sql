-- New tables for School Information System

-- Student Profile Extensions
ALTER TABLE students 
ADD COLUMN dateOfBirth DATE,
ADD COLUMN gender ENUM('M', 'F', 'O'),
ADD COLUMN address TEXT,
ADD COLUMN phoneNumber VARCHAR(20),
ADD COLUMN emergencyContact VARCHAR(100),
ADD COLUMN emergencyPhone VARCHAR(20),
ADD COLUMN bloodType VARCHAR(5),
ADD COLUMN photoUrl VARCHAR(255),
ADD COLUMN enrollmentDate DATE,
ADD COLUMN currentStatus ENUM('Active', 'Inactive', 'Graduated', 'On Leave') DEFAULT 'Active';

-- Student Credentials
CREATE TABLE studentCredentials (
    credentialId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    studentId INT UNSIGNED NOT NULL,
    credentialNumber VARCHAR(20) NOT NULL UNIQUE,
    issueDate DATE NOT NULL,
    expiryDate DATE NOT NULL,
    qrCode VARCHAR(255),
    isActive BOOLEAN DEFAULT TRUE,
    lastPrintDate DATE,
    PRIMARY KEY (credentialId),
    FOREIGN KEY (studentId) REFERENCES students(studentId) ON DELETE CASCADE
);

-- Academic Periods
CREATE TABLE academicPeriods (
    periodId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    periodName VARCHAR(100) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    status ENUM('Active', 'Completed', 'Planned') DEFAULT 'Planned',
    PRIMARY KEY (periodId)
);

-- Departments
CREATE TABLE departments (
    departmentId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    departmentName VARCHAR(100) NOT NULL,
    description TEXT,
    headUserId INT UNSIGNED,
    PRIMARY KEY (departmentId),
    FOREIGN KEY (headUserId) REFERENCES usuarios(userId) ON DELETE SET NULL
);

-- Grade Levels
CREATE TABLE gradeLevels (
    gradeLevelId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    levelName VARCHAR(50) NOT NULL,
    description TEXT,
    PRIMARY KEY (gradeLevelId)
);

-- Student Grades
CREATE TABLE studentGrades (
    gradeId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    studentId INT UNSIGNED NOT NULL,
    courseId INT UNSIGNED NOT NULL,
    periodId INT UNSIGNED NOT NULL,
    grade DECIMAL(5,2),
    comments TEXT,
    gradedBy INT UNSIGNED,
    gradedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (gradeId),
    FOREIGN KEY (studentId) REFERENCES students(studentId) ON DELETE CASCADE,
    FOREIGN KEY (courseId) REFERENCES courses(idCourse) ON DELETE CASCADE,
    FOREIGN KEY (periodId) REFERENCES academicPeriods(periodId) ON DELETE CASCADE,
    FOREIGN KEY (gradedBy) REFERENCES usuarios(userId) ON DELETE SET NULL
);

-- Attendance
CREATE TABLE attendance (
    attendanceId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    studentId INT UNSIGNED NOT NULL,
    courseId INT UNSIGNED NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL,
    notes TEXT,
    recordedBy INT UNSIGNED,
    PRIMARY KEY (attendanceId),
    FOREIGN KEY (studentId) REFERENCES students(studentId) ON DELETE CASCADE,
    FOREIGN KEY (courseId) REFERENCES courses(idCourse) ON DELETE CASCADE,
    FOREIGN KEY (recordedBy) REFERENCES usuarios(userId) ON DELETE SET NULL
);

-- Parent/Guardian Information
CREATE TABLE parents (
    parentId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phoneNumber VARCHAR(20),
    address TEXT,
    relationship ENUM('Father', 'Mother', 'Guardian', 'Other') NOT NULL,
    PRIMARY KEY (parentId)
);

-- Student-Parent Relationship
CREATE TABLE studentParents (
    studentParentId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    studentId INT UNSIGNED NOT NULL,
    parentId INT UNSIGNED NOT NULL,
    isPrimaryContact BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (studentParentId),
    FOREIGN KEY (studentId) REFERENCES students(studentId) ON DELETE CASCADE,
    FOREIGN KEY (parentId) REFERENCES parents(parentId) ON DELETE CASCADE
);

-- Course Schedule
CREATE TABLE courseSchedule (
    scheduleId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    courseId INT UNSIGNED NOT NULL,
    periodId INT UNSIGNED NOT NULL,
    dayOfWeek ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    classroom VARCHAR(50),
    PRIMARY KEY (scheduleId),
    FOREIGN KEY (courseId) REFERENCES courses(idCourse) ON DELETE CASCADE,
    FOREIGN KEY (periodId) REFERENCES academicPeriods(periodId) ON DELETE CASCADE
);

-- Document Types
CREATE TABLE documentTypes (
    documentTypeId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    typeName VARCHAR(100) NOT NULL,
    description TEXT,
    PRIMARY KEY (documentTypeId)
);

-- Student Documents
CREATE TABLE studentDocuments (
    documentId INT UNSIGNED NOT NULL AUTO_INCREMENT,
    studentId INT UNSIGNED NOT NULL,
    documentTypeId INT UNSIGNED NOT NULL,
    documentUrl VARCHAR(255) NOT NULL,
    uploadDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    uploadedBy INT UNSIGNED,
    isVerified BOOLEAN DEFAULT FALSE,
    verifiedBy INT UNSIGNED,
    verificationDate DATETIME,
    PRIMARY KEY (documentId),
    FOREIGN KEY (studentId) REFERENCES students(studentId) ON DELETE CASCADE,
    FOREIGN KEY (documentTypeId) REFERENCES documentTypes(documentTypeId) ON DELETE CASCADE,
    FOREIGN KEY (uploadedBy) REFERENCES usuarios(userId) ON DELETE SET NULL,
    FOREIGN KEY (verifiedBy) REFERENCES usuarios(userId) ON DELETE SET NULL
);

-- Add indexes for better performance
CREATE INDEX idx_student_status ON students(currentStatus);
CREATE INDEX idx_credential_number ON studentCredentials(credentialNumber);
CREATE INDEX idx_academic_period_status ON academicPeriods(status);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_course_schedule ON courseSchedule(dayOfWeek, startTime);