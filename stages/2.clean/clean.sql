-- Data Cleaning & Wrangling --

SELECT * FROM session_stage;

-- Inspect categorical unique values --
SELECT DISTINCT device FROM session;

-- Trim & replace values in the device field --
-- E.g m - mobile d - desktop
SELECT
    device,
    IF(device="m", "Mobile", "Desktop") updated_field_device
FROM
    session_stage

UPDATE
    session_stage
SET device = if(device="m", TRIM("Mobile"), TRIM("Desktop"))

-- Remove duplicate records --
-- Method: cte and window function --
-- 201 duplicate records removed remained 2118 unique records
WITH duplicate_record AS (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY session_id, created_at, device, load_time, view_time, status) AS row_num
    FROM
        session_stage
)
SELECT
    *
FROM
    duplicate_record
WHERE
    row_num > 1

-- Enforce changes in the "session" table --
DELETE FROM session_stage 
WHERE session_id in (
SELECT
    session_id
FROM
    (SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY session_id, created_at, device, load_time, view_time, status) AS row_num
    FROM
        session_stage) AS sq
WHERE
    row_num > 1)

-- Handle null & empty values --
-- Using the default "is null" function to check records on each field, while incorporating second condition because --
-- sometimes null appear in a form of text in different variations. E.g., "", "na", "nan", "n/a"
SELECT * FROM session_stage WHERE session_id IS NULL;
SELECT * FROM session_stage WHERE created_at IS NULL;
SELECT * FROM session_stage WHERE device IS NULL OR device IN ("", "nan", "n/a");
SELECT * FROM session_stage WHERE load_time IS NULL OR load_time IN ("", "nan", "n/a");
SELECT * FROM session_stage WHERE view_time IS NULL OR view_time IN ("", "nan", "n/a");
SELECT * FROM session_stage WHERE status IS NULL OR status IN ("", "nan", "n/a");

-- Both load_time and view_time variable contains 9 records with empty values --
SELECT COUNT(*) FROM session_stage WHERE load_time IS NULL or load_time in ("", "nan", "n/a");
SELECT COUNT(*) FROM session_stage WHERE view_time IS NULL or view_time in ("", "nan", "n/a");

-- 1338 empty records in the "status" field found empty --
SELECT COUNT(*) FROM session_stage WHERE status IS NULL OR status in ("", "nan", "n/a");

-- Resolution of null and empty values --
-- As dealing with a small dataset instead of dropping the null records; it is better to fill in with the average value --
CREATE TEMPORARY TABLE temp_avg_values AS
SELECT AVG(load_time) AS avg_load_time, AVG(view_time) AS avg_view_time
FROM session_stage;

UPDATE session_stage
JOIN temp_avg_values ON 1=1
SET session_stage.load_time = IF(session_stage.load_time = "", temp_avg_values.avg_load_time, session_stage.load_time),
    session_stage.view_time = IF(session_stage.view_time = "", temp_avg_values.avg_view_time, session_stage.view_time);

DROP TEMPORARY TABLE IF EXISTS temp_avg_values;

-- Status field has empty value due to acting as an indicator whether visitor completed the registration. Instead of keeping empty --
-- made the choice to fill in with "zeros." it will act as boolean variable 0 and 1 --
UPDATE 
    session_stage 
SET 
    status = 0 
WHERE 
    status IS NULL OR status IN ("", "na","nan", "n/a");

-- Inspect & remove negative, zero and extreme values / outliers --
-- no negative, zero and negative values --
SELECT
    MIN(load_time) min_load_time,
    ROUND(AVG(load_time)) avg_load_time,
    MAX(load_time) max_load_time,
    MIN(view_time) min_view_time,
    ROUND(AVG(view_time)) avg_view_time,
    MAX(view_time) max_view_time
FROM
    session_stage;

-- Convert load_time & view_time values from "milliseconds" to "seconds" --
UPDATE session_stage
SET
    load_time = ROUND((load_time / 1000), 1),
    view_time = ROUND((view_time / 1000), 1)

-- Modify fields' data type --
-- Helps to improve efficency in terms of storage and query performance --

-- Already know the min and max values for quantiative variables, now need to check the lenght for device variable --
SELECT 
    MAX(LENGTH(device)) max_lenght 
FROM 
    session_stage;

-- Data dictionary (before and after) -- 
/*
    fields          current         changes
    session_id      INT NL          INT NOT NULL PRIMARY KEY
    created_at      VARCHAR(255)    DATE
    device          VARCHAR(255)    VARCHAR(10)
    load_time       VARCHAR(255)    DECIMAL
    view_time       VARCHAR(255)    DECIMAL
    status          VARCHAR(255)    TINYINT UNSIGNED
*/

UPDATE session_stage 
SET 
    created_at = (DATE_FORMAT(STR_TO_DATE(created_at, '%d/%m/%Y'),'%Y-%m-%d'))

ALTER TABLE session_stage
ADD CONSTRAINT PRIMARY KEY(session_id),
MODIFY COLUMN created_at DATE,
MODIFY COLUMN device VARCHAR(10),
MODIFY COLUMN load_time DECIMAL(10,1),
MODIFY COLUMN view_time DECIMAL(10,1),
MODIFY COLUMN status TINYINT UNSIGNED;