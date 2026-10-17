const mysql = require('mysql2/promise');
const dotenv = require('dotenv');
const path = require('path');

// Load file .env từ thư mục gốc
dotenv.config({ path: path.join(__dirname, '../../.env') });

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'kaipy_ecommerce',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Kiểm tra kết nối
pool.getConnection()
    .then(connection => {
        console.log('✅ Kết nối CSDL MySQL (kaipy_ecommerce) thành công!');
        connection.release();
    })
    .catch(err => {
        console.error('❌ Lỗi kết nối CSDL MySQL:', err.message);
    });

module.exports = pool;