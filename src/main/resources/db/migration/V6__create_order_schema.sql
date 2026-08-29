CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_no VARCHAR(50) NOT NULL UNIQUE,
    client_request_id VARCHAR(36) NOT NULL UNIQUE,
    dining_session_id BIGINT NULL,
    order_type VARCHAR(20) NOT NULL,
    status VARCHAR(30) NOT NULL,
    taken_by_user_id BIGINT NULL,
    note VARCHAR(1000),
    subtotal_amount DECIMAL(19, 2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(19, 2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(19, 2) NOT NULL DEFAULT 0,
    paid_at DATETIME(6),
    cancel_reason_id BIGINT,
    cancel_note VARCHAR(1000),
    cancelled_by_user_id BIGINT,
    cancelled_at DATETIME(6),
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_orders_type
        CHECK (
            order_type IN (
                'DINE_IN',
                'TAKEAWAY',
                'DELIVERY'
            )
        ),

    CONSTRAINT chk_orders_status
        CHECK (
            status IN (
               'DRAFT',
               'SERVING',
               'WAITING_PAYMENT',
               'PAID',
               'CANCELLED'
            )
        ),

    CONSTRAINT chk_orders_session
        CHECK (
            (
                order_type = 'DINE_IN'
                AND dining_session_id IS NOT NULL
            )
            OR
            (
                order_type IN ('TAKEAWAY', 'DELIVERY')
                AND dining_session_id IS NULL
            )
        ),

    CONSTRAINT chk_orders_amounts
        CHECK (
            subtotal_amount >= 0
            AND discount_amount >= 0
            AND discount_amount <= subtotal_amount
            AND total_amount >= 0
            AND total_amount =
                subtotal_amount - discount_amount
        ),

    CONSTRAINT fk_orders_dining_session
        FOREIGN KEY (dining_session_id)
        REFERENCES dining_sessions (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_taken_by
        FOREIGN KEY (taken_by_user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_cancel_reason
        FOREIGN KEY (cancel_reason_id)
        REFERENCES cancellation_reasons (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_cancelled_by
        FOREIGN KEY (cancelled_by_user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    INDEX idx_orders_session_status (
        dining_session_id,
        status
    ),

    INDEX idx_orders_status_created (
        status,
        created_at
    ),

    INDEX idx_orders_taken_by_created (
        taken_by_user_id,
        created_at
    )
);

CREATE TABLE order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    client_line_id VARCHAR(36) NOT NULL,
    menu_item_id BIGINT NOT NULL,
    preparation_station_id BIGINT NOT NULL,
    item_code_snapshot VARCHAR(100) NOT NULL,
    item_name_snapshot VARCHAR(150) NOT NULL,
    quantity BIGINT NOT NULL,
    unit_price DECIMAL(19, 2) NOT NULL,
    line_total DECIMAL(19, 2) NOT NULL,
    note VARCHAR(1000),
    cancel_reason_id BIGINT,
    cancel_note VARCHAR(1000),
    cancelled_by_user_id BIGINT,
    cancelled_at DATETIME(6),
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT uk_order_items_client_line
         UNIQUE (order_id, client_line_id),

    CONSTRAINT chk_order_items_quantity
         CHECK (quantity > 0),

    CONSTRAINT chk_order_items_amounts
        CHECK (
            unit_price >= 0
            AND line_total >= 0
            AND line_total = unit_price * quantity
        ),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_items_menu_item
        FOREIGN KEY (menu_item_id)
        REFERENCES menu_items (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_items_station
        FOREIGN KEY (preparation_station_id)
        REFERENCES preparation_stations (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_items_cancel_reason
        FOREIGN KEY (cancel_reason_id)
        REFERENCES cancellation_reasons (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_items_cancelled_by
        FOREIGN KEY (cancelled_by_user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    INDEX idx_order_items_order_status (
        order_id,
        status
    )
);