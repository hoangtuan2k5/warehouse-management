CREATE DATABASE IF NOT EXISTS warehouse_management
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE warehouse_management;

DROP TABLE IF EXISTS stock_outputs;
DROP TABLE IF EXISTS stock_entries;
DROP TABLE IF EXISTS inventory_checks;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS warehouses;

CREATE TABLE suppliers (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  contact VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE warehouses (
  id INT NOT NULL AUTO_INCREMENT,
  location VARCHAR(255) NOT NULL,
  manager VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE customers (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE products (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  sku VARCHAR(50) NOT NULL,
  quantity INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY sku (sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE inventory_checks (
  id INT NOT NULL AUTO_INCREMENT,
  product_id INT NOT NULL,
  warehouse_id INT NOT NULL,
  actual_quantity INT NOT NULL,
  check_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY product_id (product_id),
  KEY warehouse_id (warehouse_id),
  CONSTRAINT inventory_checks_product_fk FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
  CONSTRAINT inventory_checks_warehouse_fk FOREIGN KEY (warehouse_id) REFERENCES warehouses (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE stock_entries (
  id INT NOT NULL AUTO_INCREMENT,
  product_id INT NOT NULL,
  supplier_id INT,
  warehouse_id INT NOT NULL,
  quantity INT NOT NULL,
  entry_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY product_id (product_id),
  KEY supplier_id (supplier_id),
  KEY warehouse_id (warehouse_id),
  CONSTRAINT stock_entries_product_fk FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
  CONSTRAINT stock_entries_supplier_fk FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE SET NULL,
  CONSTRAINT stock_entries_warehouse_fk FOREIGN KEY (warehouse_id) REFERENCES warehouses (id) ON DELETE CASCADE,
  CONSTRAINT stock_entries_quantity_chk CHECK (quantity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE stock_outputs (
  id INT NOT NULL AUTO_INCREMENT,
  product_id INT NOT NULL,
  customer_id INT,
  warehouse_id INT NOT NULL,
  quantity INT NOT NULL,
  output_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY product_id (product_id),
  KEY customer_id (customer_id),
  KEY warehouse_id (warehouse_id),
  CONSTRAINT stock_outputs_product_fk FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
  CONSTRAINT stock_outputs_customer_fk FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE SET NULL,
  CONSTRAINT stock_outputs_warehouse_fk FOREIGN KEY (warehouse_id) REFERENCES warehouses (id) ON DELETE CASCADE,
  CONSTRAINT stock_outputs_quantity_chk CHECK (quantity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO suppliers (name, contact) VALUES
  ('Công ty TNHH Thực phẩm Xanh', '0901234567'),
  ('Công ty CP Điện tử Việt Nam', '0912345678'),
  ('Nhà cung cấp Vật tư Y tế', '0923456789'),
  ('Công ty TNHH Sách và Văn phòng phẩm', '0934567890'),
  ('Nhà phân phối Đồ gia dụng', '0945678901');

INSERT INTO warehouses (location, manager) VALUES
  ('Kho A - 123 Lê Lợi, Quận 1', 'Nguyễn Văn An'),
  ('Kho B - 456 Nguyễn Huệ, Quận 2', 'Trần Thị Bình'),
  ('Kho C - 789 Hai Bà Trưng, Quận 3', 'Lê Văn Cường'),
  ('Kho D - 101 Phạm Ngũ Lão, Quận 1', 'Phạm Thị Dung'),
  ('Kho E - 202 Lý Thường Kiệt, Quận 5', 'Hoàng Văn Em');

INSERT INTO customers (name, phone) VALUES
  ('Siêu thị Co.opmart', '0901111111'),
  ('Cửa hàng MiniStop', '0902222222'),
  ('Đại lý Bách Hóa Xanh', '0903333333'),
  ('Công ty Xuất nhập khẩu ABC', '0904444444'),
  ('Khách hàng lẻ - Nguyễn Văn X', '0905555555');

INSERT INTO products (name, sku, quantity) VALUES
  ('Gạo thơm 5kg', 'FOOD-001', 120),
  ('Nước suối 500ml', 'FOOD-002', 300),
  ('Bàn phím văn phòng', 'ELEC-001', 45),
  ('Chuột không dây', 'ELEC-002', 60),
  ('Khẩu trang y tế', 'MED-001', 500),
  ('Sổ tay A5', 'BOOK-001', 180),
  ('Nồi inox 24cm', 'HOME-001', 35),
  ('Bình giữ nhiệt', 'HOME-002', 70);

INSERT INTO stock_entries (product_id, supplier_id, warehouse_id, quantity) VALUES
  (1, 1, 1, 120),
  (2, 1, 1, 300),
  (3, 2, 2, 45),
  (4, 2, 2, 60),
  (5, 3, 3, 500),
  (6, 4, 4, 180),
  (7, 5, 5, 35),
  (8, 5, 5, 70);

INSERT INTO stock_outputs (product_id, customer_id, warehouse_id, quantity) VALUES
  (1, 1, 1, 10),
  (2, 2, 1, 24),
  (5, 3, 3, 50);

INSERT INTO inventory_checks (product_id, warehouse_id, actual_quantity) VALUES
  (1, 1, 110),
  (2, 1, 276),
  (5, 3, 450);
