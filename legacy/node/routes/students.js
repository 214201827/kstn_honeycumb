const express = require('express');
const router = express.Router();
const db = require('../config/db');
const authenticateToken = require('../middleware/auth');

// Get student grades
router.get('/:studentId/grades', authenticateToken, async (req, res) => {
    try {
        const { studentId } = req.params;
        const { periodId } = req.query;
        
        let query = `
            SELECT g.*, c.courseName, p.periodName, u.names as gradedByName
            FROM studentGrades g
            JOIN courses c ON g.courseId = c.idCourse
            JOIN academicPeriods p ON g.periodId = p.periodId
            LEFT JOIN usuarios u ON g.gradedBy = u.userId
            WHERE g.studentId = ?
        `;
        
        if (periodId) {
            query += ' AND g.periodId = ?';
        }
        
        const grades = await db.query(query, periodId ? [studentId, periodId] : [studentId]);
        res.json(grades);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get student attendance
router.get('/:studentId/attendance', authenticateToken, async (req, res) => {
    try {
        const { studentId } = req.params;
        const { startDate, endDate } = req.query;
        
        let query = `
            SELECT a.*, c.courseName, u.names as recordedByName
            FROM attendance a
            JOIN courses c ON a.courseId = c.idCourse
            LEFT JOIN usuarios u ON a.recordedBy = u.userId
            WHERE a.studentId = ?
        `;
        
        if (startDate && endDate) {
            query += ' AND a.date BETWEEN ? AND ?';
        }
        
        const attendance = await db.query(
            query, 
            startDate && endDate ? [studentId, startDate, endDate] : [studentId]
        );
        
        res.json(attendance);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get student documents
router.get('/:studentId/documents', authenticateToken, async (req, res) => {
    try {
        const { studentId } = req.params;
        
        const query = `
            SELECT d.*, dt.typeName, u1.names as uploadedByName, u2.names as verifiedByName
            FROM studentDocuments d
            JOIN documentTypes dt ON d.documentTypeId = dt.documentTypeId
            LEFT JOIN usuarios u1 ON d.uploadedBy = u1.userId
            LEFT JOIN usuarios u2 ON d.verifiedBy = u2.userId
            WHERE d.studentId = ?
        `;
        
        const documents = await db.query(query, [studentId]);
        res.json(documents);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update student profile
router.put('/:studentId', authenticateToken, async (req, res) => {
    try {
        const { studentId } = req.params;
        const updateData = req.body;
        
        const query = `
            UPDATE students
            SET ?
            WHERE studentId = ?
        `;
        
        await db.query(query, [updateData, studentId]);
        res.json({ message: 'Student profile updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;