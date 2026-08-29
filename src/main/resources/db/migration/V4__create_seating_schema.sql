CREATE TABLE areas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    area_type VARCHAR(50) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_areas_type
        CHECK (
            area_type IN (
                'FLOOR',
                'ROOM',
                'OUTDOOR',
                'OTHER'
            )
        ),

    CONSTRAINT chk_areas_sort_order
        CHECK (sort_order >= 0)
);

CREATE TABLE restaurant_tables (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    area_id BIGINT NOT NULL,
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    capacity INT NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_restaurant_tables_capacity
       CHECK (capacity > 0),

    CONSTRAINT chk_restaurant_tables_sort_order
       CHECK (sort_order >= 0),

    CONSTRAINT fk_restaurant_tables_area_id
       FOREIGN KEY (area_id)
       REFERENCES areas (id)
       ON DELETE RESTRICT,

    INDEX idx_restaurant_tables_area_active_sort (
        area_id,
        active,
        sort_order
    )
);