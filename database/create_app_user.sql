CREATE USER IF NOT EXISTS 'warehouse_app'@'localhost' IDENTIFIED BY 'warehouse123';
GRANT SELECT, INSERT, UPDATE, DELETE ON warehouse_management.* TO 'warehouse_app'@'localhost';
FLUSH PRIVILEGES;
