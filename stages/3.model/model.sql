-- Data Modelling --

-- Create "device" table --
CREATE TABLE IF NOT EXISTS device(
    device_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(10),
PRIMARY KEY (device_id)
);

-- Insert unique values to respective entity --
INSERT INTO device(name)
SELECT DISTINCT device FROM session_stage ORDER BY device;

-- Establishing relationship & update records --
ALTER TABLE session_stage
ADD COLUMN device_id INT AFTER device,
ADD FOREIGN KEY (device_id) REFERENCES device(device_id) ON DELETE CASCADE ON UPDATE cascade;

UPDATE session_stage AS s
INNER JOIN device AS d ON s.device = d.name
SET s.device_id = d.device_id;

ALTER Table session_stage
DROP COLUMN device;