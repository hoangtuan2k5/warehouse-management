# Chạy dự án trên Windows

## 1. Cài phần mềm

- MySQL Server 8.x
- JDK 21
- Maven

## 2. Import database

Mở CMD tại thư mục gốc codebase, nơi có file `warehouse_management_full_backup.sql`, rồi chạy:

```bat
mysql -u root -p --default-character-set=utf8mb4 < warehouse_management_full_backup.sql
```

File backup sẽ tạo:

- Database `warehouse_management`
- User `warehouse_app` mật khẩu `warehouse123`
- Toàn bộ bảng và dữ liệu hiện tại, gồm hơn 50.000 sản phẩm

Kiểm tra:

```bat
mysql -u warehouse_app -pwarehouse123 warehouse_management -e "SELECT COUNT(*) FROM products;"
```

## 3. Chạy Spring Boot

```bat
cd warehouse-management
mvn spring-boot:run
```

Mở trình duyệt:

```text
http://localhost:8080
```

Nếu đổi user/password MySQL, sửa file:

```text
warehouse-management\src\main\resources\application.properties
```
