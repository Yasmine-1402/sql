-- 1. Vendors first (no dependencies)
CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    portal_ticketing_system VARCHAR(255),
    portal_username VARCHAR(255),
    portal_password VARCHAR(255),
    main_contact_name VARCHAR(255),
    main_contact_email VARCHAR(255),
    main_contact_mobile VARCHAR(20),
    escalation_level_1_contact_name VARCHAR(255),
    escalation_level_1_contact_email VARCHAR(255),
    escalation_level_1_contact_mobile VARCHAR(20),
    escalation_level_2_contact_name VARCHAR(255),
    escalation_level_2_contact_email VARCHAR(255),
    escalation_level_2_contact_mobile VARCHAR(20)
);

-- 2. Users (depends on vendors)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    username VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE,
    vendor_id INTEGER,
    title VARCHAR(255),
    date_of_employment DATE,
    birthdate DATE,
    tools_used VARCHAR(255),
    mobile_number VARCHAR(20),
    emergency_contact VARCHAR(255),
    department VARCHAR(255),
    role VARCHAR(255),
    second_admin_name VARCHAR(255),
    user_type VARCHAR(50),
    CONSTRAINT fk_vendor FOREIGN KEY (vendor_id) REFERENCES vendors(id)
);

-- 3. Applications (depends on vendors, users)
CREATE TABLE applications (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    reported_by_user_id INTEGER,
    vendor_id INTEGER,
    CONSTRAINT fk_reported_user FOREIGN KEY (reported_by_user_id) REFERENCES users(id),
    CONSTRAINT fk_vendor_app FOREIGN KEY (vendor_id) REFERENCES vendors(id)
);

-- 4. Knowledge Base (depends on vendors, applications, users)
CREATE TABLE knowledge_base (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    application_name VARCHAR(255),
    solutions_steps TEXT,
    attached_docs TEXT,
    application_version VARCHAR(50),
    image_url VARCHAR(255),
    vendor_id INTEGER,
    application_id INTEGER,
    reported_by_user_id INTEGER,
    CONSTRAINT fk_vendor_kb FOREIGN KEY (vendor_id) REFERENCES vendors(id),
    CONSTRAINT fk_app_kb FOREIGN KEY (application_id) REFERENCES applications(id),
    CONSTRAINT fk_user_kb FOREIGN KEY (reported_by_user_id) REFERENCES users(id)
);

-- 5. Solutions (depends on knowledge_base)
CREATE TABLE solutions (
    id SERIAL PRIMARY KEY,
    knowledge_base_id INTEGER NOT NULL,
    solution_text TEXT,
    attached_docs TEXT,
    CONSTRAINT fk_kb_solution FOREIGN KEY (knowledge_base_id) REFERENCES knowledge_base(id)
);

-- 6. Concerned Teams (depends on applications)
CREATE TABLE concerned_teams (
    id SERIAL PRIMARY KEY,
    team_name VARCHAR(255) NOT NULL,
    application_id INTEGER,
    CONSTRAINT fk_app_team FOREIGN KEY (application_id) REFERENCES applications(id)
);

-- 7. Backups (depends on applications)
CREATE TABLE backups (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL,
    backup_mode VARCHAR(50),
    frequency VARCHAR(50),
    latest_date DATE,
    interval_data VARCHAR(255),
    file_path VARCHAR(255),
    backup_type VARCHAR(50),
    CONSTRAINT fk_app_backup FOREIGN KEY (application_id) REFERENCES applications(id)
);

-- 8. Racks (no dependencies yet)
CREATE TABLE racks (
    id SERIAL PRIMARY KEY,
    number_of_servers INTEGER,
    number_of_pdus INTEGER,
    number_of_switches INTEGER
);

-- 9. Servers (depends on applications, racks)
CREATE TABLE servers (
    id SERIAL PRIMARY KEY,
    ip_address VARCHAR(50),
    ip_type VARCHAR(50),
    application_id INTEGER,
    os_name VARCHAR(50),
    server_type VARCHAR(50),
    data_center_name VARCHAR(255),
    x_coord VARCHAR(50),
    y_coord VARCHAR(50),
    room_name VARCHAR(255),
    rack_id INTEGER,
    window_contact VARCHAR(255),
    support_status VARCHAR(50),
    support_end_of_service_date DATE,
    CONSTRAINT fk_app_server FOREIGN KEY (application_id) REFERENCES applications(id),
    CONSTRAINT fk_rack_server FOREIGN KEY (rack_id) REFERENCES racks(id)
);

-- 10. Databases (depends on applications)
CREATE TABLE databases (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    url_address VARCHAR(255),
    port INTEGER,
    type VARCHAR(50),
    application_id INTEGER,
    username VARCHAR(255),
    password VARCHAR(255),
    current_version VARCHAR(50),
    last_update DATE,
    planned_update DATE,
    CONSTRAINT fk_app_db FOREIGN KEY (application_id) REFERENCES applications(id)
);
