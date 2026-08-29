INSERT INTO permissions (code, description)
VALUES
    ('ORDER_CREATE', 'Create an order'),
    ('ORDER_UPDATE', 'Update an order'),
    ('ORDER_SEND_KITCHEN', 'Send an order to the kitchen'),
    ('ORDER_CANCEL_ITEM', 'Cancel an order item'),
    ('ORDER_CANCEL', 'Cancel an order'),
    ('ORDER_DISCOUNT', 'Apply a discount to an order'),
    ('ORDER_PAY', 'Process payment for an order'),
    ('MENU_CREATE', 'Create menu items'),
    ('MENU_UPDATE', 'Update menu items'),
    ('MENU_PRICE_UPDATE', 'Update menu prices'),
    ('REPORT_VIEW', 'View reports'),
    ('USER_MANAGE', 'Manage users and role assignments'),
    ('SYSTEM_CONFIGURE', 'Configure system settings');

INSERT INTO roles (
   code,
   name,
   description,
   system_role,
   active,
   created_at,
   updated_at
)
VALUES
    (
        'ADMIN',
        'Administrator',
        'Full system administrator',
        TRUE,
        TRUE,
        CURRENT_TIMESTAMP(6),
        CURRENT_TIMESTAMP(6)
    ),
    (
        'MANAGER',
        'Manager',
        'Restaurant manager',
        TRUE,
        TRUE,
        CURRENT_TIMESTAMP(6),
        CURRENT_TIMESTAMP(6)
    ),
    (
        'CASHIER',
        'Cashier',
        'Handles payments and cashier operations',
        TRUE,
        TRUE,
        CURRENT_TIMESTAMP(6),
        CURRENT_TIMESTAMP(6)
    ),
    (
        'WAITER',
        'Waiter',
        'Creates and manages customer orders',
        TRUE,
        TRUE,
        CURRENT_TIMESTAMP(6),
        CURRENT_TIMESTAMP(6)
    ),
    (
        'KITCHEN',
        'Kitchen',
        'Handles orders sent to the kitchen',
        TRUE,
        TRUE,
        CURRENT_TIMESTAMP(6),
        CURRENT_TIMESTAMP(6)
    );