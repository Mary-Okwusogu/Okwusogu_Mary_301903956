USE blitzfintech_db;

CREATE TABLE IF NOT EXISTS customer (
    customer_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_number VARCHAR(30) NOT NULL,
    party_type VARCHAR(20) NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(254) NULL,
    phone VARCHAR(30) NULL,
    customer_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    kyc_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    risk_rating VARCHAR(20) NOT NULL DEFAULT 'STANDARD',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_customer_number UNIQUE (customer_number),
    CONSTRAINT uq_customer_email UNIQUE (email),
    CONSTRAINT chk_customer_party_type CHECK (party_type IN ('INDIVIDUAL','ORGANISATION')),
    CONSTRAINT chk_customer_status CHECK (customer_status IN ('PENDING','ACTIVE','SUSPENDED','CLOSED')),
    CONSTRAINT chk_customer_kyc_status CHECK (kyc_status IN ('PENDING','IN_REVIEW','APPROVED','REJECTED','EXPIRED')),
    CONSTRAINT chk_customer_risk CHECK (risk_rating IN ('LOW','STANDARD','HIGH'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS individual_customer (
    customer_id BIGINT UNSIGNED PRIMARY KEY,
    date_of_birth DATE NULL,
    identity_country CHAR(2) NULL,
    identity_reference VARCHAR(100) NULL,
    CONSTRAINT fk_individual_customer FOREIGN KEY (customer_id)
      REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS organisation_customer (
    customer_id BIGINT UNSIGNED PRIMARY KEY,
    registration_number VARCHAR(100) NULL,
    registration_country CHAR(2) NULL,
    incorporated_at DATE NULL,
    CONSTRAINT uq_organisation_registration UNIQUE (registration_country, registration_number),
    CONSTRAINT fk_organisation_customer FOREIGN KEY (customer_id)
      REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS account (
    account_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(34) NOT NULL,
    account_type VARCHAR(30) NOT NULL,
    currency CHAR(3) NOT NULL,
    balance DECIMAL(19,4) NOT NULL DEFAULT 0.0000,
    account_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL,
    CONSTRAINT uq_account_number UNIQUE (account_number),
    CONSTRAINT chk_account_balance CHECK (balance >= 0),
    CONSTRAINT chk_account_type CHECK (account_type IN ('SAVINGS','CURRENT','BUSINESS','WALLET')),
    CONSTRAINT chk_account_status CHECK (account_status IN ('PENDING','ACTIVE','FROZEN','CLOSED'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS account_party (
    account_id BIGINT UNSIGNED NOT NULL,
    customer_id BIGINT UNSIGNED NOT NULL,
    party_role VARCHAR(30) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (account_id, customer_id, party_role),
    CONSTRAINT fk_ap_account FOREIGN KEY (account_id)
      REFERENCES account(account_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_ap_customer FOREIGN KEY (customer_id)
      REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_ap_role CHECK (party_role IN ('HOLDER','JOINT_HOLDER','BENEFICIAL_OWNER','SIGNATORY'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS kyc_case (
    kyc_case_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED NOT NULL,
    case_type VARCHAR(30) NOT NULL DEFAULT 'ONBOARDING',
    case_status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    opened_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL,
    CONSTRAINT fk_kyc_case_customer FOREIGN KEY (customer_id)
      REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_kyc_case_type CHECK (case_type IN ('ONBOARDING','PERIODIC_REVIEW','EVENT_DRIVEN')),
    CONSTRAINT chk_kyc_case_status CHECK (case_status IN ('OPEN','IN_REVIEW','APPROVED','REJECTED','CLOSED'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS customer_document (
    document_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED NOT NULL,
    kyc_case_id BIGINT UNSIGNED NULL,
    document_type VARCHAR(40) NOT NULL,
    storage_object_key VARCHAR(512) NOT NULL,
    sha256_checksum CHAR(64) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    issued_at DATE NULL,
    expires_at DATE NULL,
    verification_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_document_customer FOREIGN KEY (customer_id)
      REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_document_kyc_case FOREIGN KEY (kyc_case_id)
      REFERENCES kyc_case(kyc_case_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_document_status CHECK (verification_status IN ('PENDING','VERIFIED','REJECTED','EXPIRED')),
    CONSTRAINT chk_document_dates CHECK (expires_at IS NULL OR issued_at IS NULL OR expires_at >= issued_at),
    INDEX idx_document_customer_status (customer_id, verification_status),
    INDEX idx_document_expiry (expires_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS kyc_review (
    kyc_review_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    kyc_case_id BIGINT UNSIGNED NOT NULL,
    reviewer_user_id VARCHAR(100) NOT NULL,
    decision VARCHAR(20) NOT NULL,
    reason VARCHAR(1000) NOT NULL,
    reviewed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_case FOREIGN KEY (kyc_case_id)
      REFERENCES kyc_case(kyc_case_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_review_decision CHECK (decision IN ('APPROVED','REJECTED','MORE_INFO')),
    INDEX idx_review_case_time (kyc_case_id, reviewed_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS account_mandate (
    mandate_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    mandate_reference VARCHAR(64) NOT NULL,
    mandate_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    effective_from DATE NOT NULL,
    effective_to DATE NULL,
    required_approvals TINYINT UNSIGNED NOT NULL DEFAULT 1,
    evidence_object_key VARCHAR(512) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_mandate_reference UNIQUE (mandate_reference),
    CONSTRAINT fk_mandate_account FOREIGN KEY (account_id)
      REFERENCES account(account_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_mandate_status CHECK (mandate_status IN ('PENDING','ACTIVE','SUSPENDED','REVOKED','EXPIRED')),
    CONSTRAINT chk_mandate_dates CHECK (effective_to IS NULL OR effective_to >= effective_from),
    CONSTRAINT chk_mandate_approvals CHECK (required_approvals >= 1)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS mandate_signatory (
    mandate_id BIGINT UNSIGNED NOT NULL,
    customer_id BIGINT UNSIGNED NOT NULL,
    authority_role VARCHAR(30) NOT NULL DEFAULT 'STANDARD',
    individual_limit DECIMAL(19,4) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (mandate_id, customer_id),
    CONSTRAINT fk_ms_mandate FOREIGN KEY (mandate_id)
      REFERENCES account_mandate(mandate_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_ms_customer FOREIGN KEY (customer_id)
      REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_ms_limit CHECK (individual_limit IS NULL OR individual_limit >= 0),
    CONSTRAINT chk_ms_authority CHECK (authority_role IN ('STANDARD','ADMINISTRATOR','VIEW_ONLY')),
    INDEX idx_ms_customer (customer_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS financial_transaction (
    transaction_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transaction_reference VARCHAR(64) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(19,4) NOT NULL,
    currency CHAR(3) NOT NULL,
    transaction_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    initiated_by VARCHAR(100) NOT NULL,
    idempotency_key VARCHAR(100) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    posted_at TIMESTAMP NULL,
    CONSTRAINT uq_transaction_reference UNIQUE (transaction_reference),
    CONSTRAINT uq_transaction_idempotency UNIQUE (idempotency_key),
    CONSTRAINT chk_transaction_amount CHECK (amount > 0),
    CONSTRAINT chk_transaction_type CHECK (transaction_type IN ('DEPOSIT','WITHDRAWAL','TRANSFER','REVERSAL')),
    CONSTRAINT chk_transaction_status CHECK (transaction_status IN ('PENDING','POSTED','FAILED','REVERSED')),
    INDEX idx_transaction_status_time (transaction_status, created_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ledger_entry (
    ledger_entry_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transaction_id BIGINT UNSIGNED NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    entry_type VARCHAR(10) NOT NULL,
    amount DECIMAL(19,4) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ledger_transaction FOREIGN KEY (transaction_id)
      REFERENCES financial_transaction(transaction_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_ledger_account FOREIGN KEY (account_id)
      REFERENCES account(account_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_ledger_entry_type CHECK (entry_type IN ('DEBIT','CREDIT')),
    CONSTRAINT chk_ledger_amount CHECK (amount > 0),
    INDEX idx_ledger_account_time (account_id, created_at),
    INDEX idx_ledger_transaction (transaction_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS transaction_approval (
    approval_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    transaction_id BIGINT UNSIGNED NOT NULL,
    mandate_id BIGINT UNSIGNED NOT NULL,
    approver_customer_id BIGINT UNSIGNED NOT NULL,
    decision VARCHAR(20) NOT NULL,
    decision_reason VARCHAR(1000) NULL,
    decided_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_transaction_approver UNIQUE (transaction_id, approver_customer_id),
    CONSTRAINT fk_approval_transaction FOREIGN KEY (transaction_id)
      REFERENCES financial_transaction(transaction_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_approval_mandate FOREIGN KEY (mandate_id)
      REFERENCES account_mandate(mandate_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_approval_customer FOREIGN KEY (approver_customer_id)
      REFERENCES customer(customer_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_approval_decision CHECK (decision IN ('APPROVED','REJECTED','ABSTAIN')),
    INDEX idx_approval_mandate (mandate_id, decided_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS idempotency_request (
    idempotency_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idempotency_key VARCHAR(100) NOT NULL,
    request_hash CHAR(64) NOT NULL,
    transaction_id BIGINT UNSIGNED NULL,
    request_status VARCHAR(20) NOT NULL DEFAULT 'PROCESSING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_idempotency_request_key UNIQUE (idempotency_key),
    CONSTRAINT fk_idempotency_transaction FOREIGN KEY (transaction_id)
      REFERENCES financial_transaction(transaction_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_idempotency_status CHECK (request_status IN ('PROCESSING','COMPLETED','FAILED')),
    INDEX idx_idempotency_transaction (transaction_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS audit_log (
    audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    actor_type VARCHAR(20) NOT NULL,
    actor_id VARCHAR(100) NOT NULL,
    action_type VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id VARCHAR(100) NOT NULL,
    event_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reason VARCHAR(1000) NULL,
    before_data JSON NULL,
    after_data JSON NULL,
    CONSTRAINT chk_audit_actor_type CHECK (actor_type IN ('USER','SYSTEM','SERVICE')),
    INDEX idx_audit_entity_time (entity_type, entity_id, event_timestamp),
    INDEX idx_audit_actor_time (actor_id, event_timestamp)
) ENGINE=InnoDB;
