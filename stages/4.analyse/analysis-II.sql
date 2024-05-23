-- Analysis II (deeper): why the number of registrations has dropped 18th onwards? --

-- How does the page load time and duration differs between visitors completed registration and those who didn't -- 
SELECT
    IF(status=1, "registrant", "non-registrant") AS conversion,
    ROUND(AVG(load_time)  ,1) AS avg_page_load,
    ROUND(AVG(view_time),1) AS avg_page_view
FROM
    session_stage
WHERE 
    EXTRACT(DAY FROM created_at) > 18
GROUP BY
    status;

-- Are there any preferable device between those who completed registration and did not? --
SELECT 
    status,
    d.name,
    COUNT(t.device_id) AS no_traffic
FROM 
    session_stage t
JOIN
    device d ON t.device_id = d.device_id
WHERE 
    EXTRACT(DAY FROM created_at) > 18
GROUP BY 
    status, t.device_id
ORDER BY 
    status ASC

-- What made desktop users to register easily during peak time than mobile users? --
-- Are there any difference in load and view time between devices? --
SELECT 
    status,
    d.name,
    ROUND(AVG(t.view_time),1) AS avg_page_view_time,
    ROUND(AVG(t.load_time),1) AS avg_page_load_time
FROM 
    session_stage t
JOIN
    device d ON t.device_id = d.device_id
WHERE 
    EXTRACT(DAY FROM created_at) > 19
GROUP BY 
    status, d.name
ORDER BY 
    status;

-- Where there any particular day of the month had fluctuation of bandwidth causing load time between devices? --
SELECT
    device_id,
    EXTRACT(DAY FROM created_at) AS days,
    ROUND(AVG(load_time),2) AS avg_load_time
FROM
    session_stage
GROUP BY
    device_id, days
ORDER BY 
    device_id, days

-- By eighteen website load-time becomes 10x compared two weeks earlier, and remained the same across.
-- This proves that there were issue with loading for mobile causing lot of delay and making user impataince and not complete the registration.
SELECT
    d.name,
    EXTRACT(DAY FROM s.created_at) AS days,
    ROUND(AVG(s.view_time),2) AS avg_view_time
FROM
    session_stage s
JOIN
    device d ON s.device_id = d.device_id
GROUP BY d.name, days