package com.minhhieu.warehouse;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
class ProductController {
    private final JdbcTemplate jdbc;

    ProductController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/api/products")
    List<Product> products(@RequestParam(defaultValue = "") String q) {
        String keyword = q.trim();
        return jdbc.query("""
                SELECT id, name, sku, quantity, DATE_FORMAT(created_at, '%Y-%m-%d %H:%i') AS created_at
                FROM products
                WHERE ? = '' OR name LIKE CONCAT('%', ?, '%') OR sku LIKE CONCAT('%', ?, '%')
                ORDER BY id DESC
                LIMIT 100
                """,
                (rs, rowNum) -> new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("sku"),
                        rs.getInt("quantity"),
                        rs.getString("created_at")),
                keyword, keyword, keyword);
    }

    @PostMapping("/api/products")
    Map<String, Object> create(@RequestBody ProductRequest input) {
        ProductRequest product = valid(input);
        try {
            jdbc.update("INSERT INTO products (name, sku, quantity) VALUES (?, ?, ?)",
                    product.name().trim(), product.sku().trim(), product.quantity());
            return Map.of("ok", true);
        } catch (DuplicateKeyException e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "SKU đã tồn tại");
        }
    }

    @PutMapping("/api/products/{id}")
    Map<String, Object> update(@PathVariable int id, @RequestBody ProductRequest input) {
        ProductRequest product = valid(input);
        try {
            int rows = jdbc.update("UPDATE products SET name = ?, sku = ?, quantity = ? WHERE id = ?",
                    product.name().trim(), product.sku().trim(), product.quantity(), id);
            if (rows == 0) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm");
            }
            return Map.of("ok", true);
        } catch (DuplicateKeyException e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "SKU đã tồn tại");
        }
    }

    @DeleteMapping("/api/products/{id}")
    Map<String, Object> delete(@PathVariable int id) {
        int rows = jdbc.update("DELETE FROM products WHERE id = ?", id);
        if (rows == 0) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy sản phẩm");
        }
        return Map.of("ok", true);
    }

    private ProductRequest valid(ProductRequest input) {
        if (input == null || blank(input.name()) || blank(input.sku())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tên và SKU là bắt buộc");
        }
        if (input.quantity() < 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Số lượng không được âm");
        }
        return input;
    }

    private boolean blank(String value) {
        return value == null || value.trim().isEmpty();
    }

    record Product(int id, String name, String sku, int quantity, String createdAt) {
    }

    record ProductRequest(String name, String sku, int quantity) {
    }
}
