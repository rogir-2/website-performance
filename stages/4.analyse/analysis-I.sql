-- Analysis I: Performance Overview --

-- Total sessions: how many sessions were generated during the trial month (december)? --
SELECT
    DISTINCT COUNT(session_id) AS no_session
FROM
    session_stage

-- Device usage: what type of devices did visitors predominately use to access? --
SELECT
    d.name AS device,
    COUNT(s.session_id) AS no_session,
    ROUND(COUNT(s.device_id) / (SELECT COUNT(session_id) FROM session_stage) * 100) AS session_per
FROM
    session_stage s
JOIN 
    device d ON s.device_id = d.device_id
GROUP BY 
    s.device_id
ORDER BY
    no_session ASC;

-- Load & duration per session (secs): what were the average load time and duration per session? --
SELECT
    ROUND(AVG(view_time),1) AS avg_view_time,
    ROUND(AVG(load_time),1) AS avg_load_time  
FROM 
    session_stage;

-- Conversion & bounce Rate: what was the percentage of completed registrations vs bounce rate? --
SELECT
    IF(status=1, "Registration", "Bounce") AS type,
    CONCAT(ROUND(COUNT(session_id) / (SELECT COUNT(session_id) FROM session_stage) * 100),"%") AS rate
FROM
    session_stage
GROUP BY 
    status

-- Monthly trend (traffic vs registration): how did traffic (sessions) correlate with registration numbers throughout december? --
-- Are there any specific trend within the number of traffic and registration? --
SELECT
    sq.days,
    total_session,
    total_conversion
FROM
    (SELECT 
        EXTRACT(DAY FROM created_at) AS days, 
        COUNT(*) AS total_conversion
    FROM 
        session_stage
    WHERE 
        status = 1
    GROUP BY 
        days 
    ORDER BY 
        days ASC) AS sq
JOIN
    (select 
        EXTRACT(DAY FROM created_at) AS days, 
        COUNT(*) AS total_session
    FROM 
        session_stage
    GROUP BY 
        days 
    ORDER BY 
        days ASC) AS sq1
ON  sq.days = sq1.days;

-- Average number of registration: What was the average registration count? --
SELECT
    ROUND(AVG(registrations)) AS avg_registration 
FROM 
    (SELECT
        EXTRACT(day FROM created_at) AS days, 
        COUNT(*) AS registrations 
    FROM
        session_stage 
    WHERE
        status = 1
    GROUP BY 
        days
    ORDER BY 
        days ASC) AS sq