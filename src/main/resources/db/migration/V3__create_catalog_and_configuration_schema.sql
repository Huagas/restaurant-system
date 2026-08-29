CREATE TABLE restaurant_profile (
    id BIGINT NOT NULL,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(500) NOT NULL,
    tax_code VARCHAR(50),
    time_zone VARCHAR(64) NOT NULL DEFAULT 'Asia/Bangkok',
    currency_code VARCHAR(3) NOT NULL DEFAULT 'VND',
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    PRIMARY KEY (id),

    CONSTRAINT chk_restaurant_profile_singleton
        CHECK (id = 1)
);

CREATE TABLE preparation_stations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    station_type VARCHAR(30) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_preparation_stations_type
      CHECK (
          station_type IN (
            'KITCHEN',
            'BAR',
            'DRINK_COUNTER'
          )
      )
);

CREATE TABLE menu_categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_menu_categories_sort_order
        CHECK (sort_order >= 0)
);

CREATE TABLE menu_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category_id BIGINT NOT NULL,
    preparation_station_id BIGINT NOT NULL,
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(1000),
    image_url VARCHAR(2048),
    list_price DECIMAL(19, 2) NOT NULL,
    sort_order INT NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_menu_items_list_price
        CHECK (list_price >= 0),

    CONSTRAINT chk_menu_items_sort_order
        CHECK (sort_order >= 0),

    CONSTRAINT fk_menu_items_category
        FOREIGN KEY (category_id)
        REFERENCES menu_categories (id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT fk_menu_items_preparation_station
        FOREIGN KEY (preparation_station_id)
        REFERENCES preparation_stations (id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    INDEX idx_menu_items_category_active_sort (
        category_id,
        active,
        sort_order
    ),

    INDEX idx_menu_items_station_active (
        preparation_station_id,
        active
    ),

    INDEX idx_menu_items_name (name)
);

CREATE TABLE sales_channels (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_sales_channels_sort_order
        CHECK (sort_order >= 0)
);

INSERT INTO sales_channels (
    code,
    name,
    active,
    sort_order,
    created_at,
    updated_at
)
VALUES (
           'POS',
           'Point of Sale',
           TRUE,
           10,
           CURRENT_TIMESTAMP(6),
           CURRENT_TIMESTAMP(6)
       ),
       (
           'PHONE',
           'Phone',
           TRUE,
           20,
           CURRENT_TIMESTAMP(6),
           CURRENT_TIMESTAMP(6)
       ),
       (
           'WEBSITE',
           'Website',
           TRUE,
           30,
           CURRENT_TIMESTAMP(6),
           CURRENT_TIMESTAMP(6)
       ),
       (
           'DELIVERY_PARTNER',
           'Delivery Partner',
           TRUE,
           40,
           CURRENT_TIMESTAMP(6),
           CURRENT_TIMESTAMP(6)
       );

CREATE TABLE cancellation_reasons (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    scope VARCHAR(30) NOT NULL,
    requires_note BOOLEAN NOT NULL DEFAULT FALSE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_cancellation_reasons_scope
        CHECK (
            scope IN (
                'ORDER_ITEM',
                'ORDER',
                'INVOICE'
            )
        ),

    CONSTRAINT chk_cancellation_reasons_sort_order
        CHECK (sort_order >= 0)
);

INSERT INTO cancellation_reasons (
    code,
    name,
    scope,
    requires_note,
    active,
    sort_order,
    created_at,
    updated_at
)
VALUES
    (
        'CUSTOMER_REQUEST',
        'Khách yêu cầu',
        'ORDER',
        FALSE,
        TRUE,
        10,
        CURRENT_TIMESTAMP(6),
        CURRENT_TIMESTAMP(6)
    ),
    (
        'OUT_OF_STOCK',
        'Hết món',
        'ORDER_ITEM',
        FALSE,
        TRUE,
        20,
        CURRENT_TIMESTAMP(6),
        CURRENT_TIMESTAMP(6)
    ),
    (
        'OTHER',
        'Lý do khác',
        'ORDER_ITEM',
        TRUE,
        TRUE,
        100,
        CURRENT_TIMESTAMP(6),
        CURRENT_TIMESTAMP(6)
    );

CREATE TABLE note_templates (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(255) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    sort_order INT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_note_templates_content
        CHECK (CHAR_LENGTH(TRIM(content)) > 0),

    CONSTRAINT chk_note_templates_sort_order
        CHECK (sort_order >= 0)
);