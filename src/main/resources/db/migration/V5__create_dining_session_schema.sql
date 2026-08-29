CREATE TABLE dining_sessions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    session_no VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL,
    opened_by_user_id BIGINT NOT NULL,
    opened_at DATETIME(6) NOT NULL,
    closed_by_user_id BIGINT,
    closed_at DATETIME(6) NOT NULL,
    close_reason VARCHAR(500),
    version BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,

    CONSTRAINT chk_dining_sessions_status
        CHECK (
            status IN (
                'OPEN',
                'CLOSED',
                'CANCELLED'
            )
        ),

    CONSTRAINT chk_dining_session_close_time
         CHECK (
            closed_at IS NULL
            OR closed_at >= opened_at
         ),

    CONSTRAINT chk_dining_sessions_closed_state
         CHECK (
            (
                status = 'OPEN'
                AND closed_at IS NULL
                AND closed_by_user_id IS NULL
            )
            OR
            (
                status IN ('CLOSED', 'CANCELLED')
                AND closed_at IS NOT NULL
                AND closed_by_user_id IS NOT NULL
            )
         ),

    CONSTRAINT fk_dining_sessions_opened_by
        FOREIGN KEY (opened_by_user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_dining_sessions_closed_by
        FOREIGN KEY (closed_by_user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    INDEX idx_dining_sessions_status_opened (
        status,
        opened_at
    )
);

CREATE TABLE session_table_assignments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    session_id BIGINT NOT NULL,
    table_id BIGINT NOT NULL,
    assigned_at DATETIME(6) NOT NULL,
    assigned_by_user_id BIGINT NOT NULL,
    released_at DATETIME(6),
    released_by_user_id BIGINT,
    release_reason VARCHAR(500),

    active_table_key BIGINT
        GENERATED ALWAYS AS (
            CASE
                WHEN released_at IS NULL
                    THEN table_id
                ELSE NULL
            END
        ) STORED,

    CONSTRAINT uk_session_table_active_table
       UNIQUE (active_table_key),

    CONSTRAINT chk_session_table_release_time
       CHECK (
           released_at IS NULL
           OR released_at >= assigned_at
       ),

    CONSTRAINT fk_session_table_session
        FOREIGN KEY (session_id)
        REFERENCES dining_sessions (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_session_table_table
        FOREIGN KEY (table_id)
        REFERENCES restaurant_tables (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_session_table_assigned_by
        FOREIGN KEY (assigned_by_user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_session_table_released_by
        FOREIGN KEY (released_by_user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    INDEX idx_session_table_session_released (
        session_id,
        released_at
    ),

    INDEX idx_session_table_table_assigned (
        table_id,
        assigned_at
    )
);