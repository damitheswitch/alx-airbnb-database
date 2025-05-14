erDiagram
    USER ||--o{ PROPERTY : "hosts"
    USER ||--o{ BOOKING : "makes"
    USER ||--o{ REVIEW : "writes"
    USER ||--o{ MESSAGE : "sends"
    USER ||--o{ MESSAGE : "receives"
    PROPERTY ||--o{ BOOKING : "has"
    PROPERTY ||--o{ REVIEW : "receives"
    BOOKING ||--o{ PAYMENT : "has"

    USER {
        string user_id PK
        string first_name
        string last_name
        string email UK
        string password_hash
        string phone_number
        string role
        timestamp created_at
    }

    PROPERTY {
        string property_id PK
        string host_id FK
        string name
        string description
        string location
        decimal pricepernight
        timestamp created_at
        timestamp updated_at
    }

    BOOKING {
        string booking_id PK
        string property_id FK
        string user_id FK
        date start_date
        date end_date
        decimal total_price
        string status
        timestamp created_at
    }

    PAYMENT {
        string payment_id PK
        string booking_id FK
        decimal amount
        timestamp payment_date
        string payment_method
    }

    REVIEW {
        string review_id PK
        string property_id FK
        string user_id FK
        int rating
        string comment
        timestamp created_at
    }

    MESSAGE {
        string message_id PK
        string sender_id FK
        string recipient_id FK
        string message_body
        timestamp sent_at
    }
