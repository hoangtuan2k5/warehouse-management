package com.minhhieu.warehouse;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class DbCheckController {
    private final JdbcTemplate jdbc;

    DbCheckController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping({"/db-check", "/api/db-check"})
    Map<String, Object> dbCheck() {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("database", jdbc.queryForObject("SELECT DATABASE()", String.class));
        result.put("products", jdbc.queryForObject("SELECT COUNT(*) FROM products", Integer.class));
        result.put("suppliers", jdbc.queryForObject("SELECT COUNT(*) FROM suppliers", Integer.class));
        result.put("warehouses", jdbc.queryForObject("SELECT COUNT(*) FROM warehouses", Integer.class));
        result.put("customers", jdbc.queryForObject("SELECT COUNT(*) FROM customers", Integer.class));
        return result;
    }
}
