erDiagram

    USER {
        uuid user_id PK "Indexed"
        varchar first_name "NOT NULL"
        varchar last_name "NOT NULL"
        varchar email "UNIQUE, NOT NULL, Indexed"
        varchar password_hash "NOT NULL"
        varchar phone_number "NULL"
        enum role "ENUM('guest','host','admin'), NOT NULL"
        timestamp created_at "DEFAULT CURRENT_TIMESTAMP"
    }

    PROPERTY {
        uuid property_id PK "Indexed"
        uuid host_id FK "references User(user_id)"
        varchar name "NOT NULL"
        text description "NOT NULL"
        varchar location "NOT NULL"
        decimal pricepernight "NOT NULL"
        timestamp created_at "DEFAULT CURRENT_TIMESTAMP"
        timestamp updated_at "ON UPDATE CURRENT_TIMESTAMP"
    }

    BOOKING {
        uuid booking_id PK "Indexed"
        uuid property_id FK "references Property(property_id)"
        uuid user_id FK "references User(user_id)"
        date start_date "NOT NULL"
        date end_date "NOT NULL"
        decimal total_price "NOT NULL"
        enum status "ENUM('pending','confirmed','canceled'), NOT NULL"
        timestamp created_at "DEFAULT CURRENT_TIMESTAMP"
    }

    PAYMENT {
        uuid payment_id PK "Indexed"
        uuid booking_id FK "references Booking(booking_id)"
        decimal amount "NOT NULL"
        timestamp payment_date "DEFAULT CURRENT_TIMESTAMP"
        enum payment_method "ENUM('credit_card','paypal','stripe'), NOT NULL"
    }

    REVIEW {
        uuid review_id PK "Indexed"
        uuid property_id FK "references Property(property_id)"
        uuid user_id FK "references User(user_id)"
        integer rating "CHECK: rating >= 1 AND rating <= 5, NOT NULL"
        text comment "NOT NULL"
        timestamp created_at "DEFAULT CURRENT_TIMESTAMP"
    }

    MESSAGE {
        uuid message_id PK "Indexed"
        uuid sender_id FK "references User(user_id)"
        uuid recipient_id FK "references User(user_id)"
        text message_body "NOT NULL"
        timestamp sent_at "DEFAULT CURRENT_TIMESTAMP"
    }

    USER ||--o{ PROPERTY : hosts
    USER ||--o{ BOOKING : makes
    PROPERTY ||--o{ BOOKING : receives
    BOOKING ||--o{ PAYMENT : generates
    USER ||--o{ REVIEW : writes
    PROPERTY ||--o{ REVIEW : receives
    USER ||--o{ MESSAGE : sends
    USER ||--o{ MESSAGE : receives
