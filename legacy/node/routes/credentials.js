const express = require('express');
const router = express.Router();
const db = require('../config/db');
const QRCode = require('qrcode');
const authenticateToken = require('../middleware/auth');

// Generate new student credential
router.post('/generate', authenticateToken, async (req, res) => {
    try {
        const { studentId } = req.body;
        const credentialNumber = await generateCredentialNumber();
        const qrCodeData = await QRCode.toDataURL(`${process.env.VERIFICATION_URL}/${credentialNumber}`);
        
        const query = `
            INSERT INTO studentCredentials (
                studentId, 
                credentialNumber, 
                issueDate, 
                expiryDate, 
                qrCode
            ) VALUES (?, ?, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 YEAR), ?)
        `;
        
        await db.query(query, [studentId, credentialNumber, qrCodeData]);
        
        res.status(201).json({ message: 'Credential generated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Verify student credential
router.get('/verify/:credentialNumber', async (req, res) => {
    try {
        const { credentialNumber } = req.params;
        
        const query = `
            SELECT c.*, s.names, s.lastNames, s.photoUrl 
            FROM studentCredentials c
            JOIN students s ON c.studentId = s.studentId
            WHERE c.credentialNumber = ? AND c.isActive = true
        `;
        
        const [credential] = await db.query(query, [credentialNumber]);
        
        if (!credential) {
            return res.status(404).json({ error: 'Invalid or expired credential' });
        }
        
        res.json(credential);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Helper function to generate unique credential number
async function generateCredentialNumber() {
    const year = new Date().getFullYear().toString().substr(-2);
    const random = Math.floor(Math.random() * 100000).toString().padStart(5, '0');
    return `${year}${random}`;
}

module.exports = router;