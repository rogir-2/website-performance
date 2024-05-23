-- Data Preparation & Collection --

-- Create database / schema --
CREATE DATABASE IF NOT EXISTS web;

-- Set default database --
USE web;

-- Create table "session" --
-- Raw records are imported here --
CREATE TABLE IF NOT EXISTS session(
    session_id      INT NOT NULL,
    created_at      VARCHAR(255),
    device          VARCHAR(255),
    load_time       VARCHAR(255),
    view_time       VARCHAR(255),
    status          VARCHAR(255)
);

-- Import csv to "web.session" --
LOAD DATA INFILE '~/sitelog.csv'
INTO TABLE session
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\\n'
IGNORE 1 LINES
(session_id, created_at, device, load_time, view_time, status);

-- Duplicate "session" structure & data --
-- New entity name: session_stage. Here data manipulation & transformation will be done without affecting the original data --
CREATE TABLE IF NOT EXISTS session_stage
LIKE session;

INSERT INTO session_stage
SELECT * FROM session;