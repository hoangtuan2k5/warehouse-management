# Warehouse Management

Spring Boot cho dự án quản lý kho. Hiện có cấu hình MySQL, schema và CRUD danh mục sản phẩm.

## Chạy

```bash
sudo mysql < ../phase-1-mysql-setup/init_schema.sql
sudo mysql < ../phase-1-mysql-setup/create_app_user.sql
mvn spring-boot:run
```

Mở:

```bash
http://localhost:8080
```

API nhanh:

```bash
curl http://localhost:8080/api/products
curl http://localhost:8080/api/db-check
```
