-- ## Investigation Steps / Questions
-- This challenge is designed to make you think like a detective — but using SQL instead of fingerprints.

-- #1. Identify where and when the crime happened

SELECT room AS crime_spot
FROM keycard_logs
WHERE entry_time = '2025-10-15 21:00:00' OR exit_time = '2025-10-15 21:00:00';

-- #2. Analyze who accessed critical areas at the time

SELECT k.log_id, k.employee_id, e.name AS employee_name, k.room, k.entry_time, k.exit_time
FROM keycard_logs k
JOIN employees e
ON k.employee_id = e.employee_id
WHERE entry_time = '2025-10-15 21:00:00' OR exit_time = '2025-10-15 21:00:00';

-- #3. Cross-check alibis with actual logs

SELECT e.employee_id, e.name, k.room AS actual_location, a.claimed_location,
    CAST(k.entry_time AS TIME) AS entry_time,
    CAST(k.exit_time AS TIME) AS exit_time,
    CAST(a.claim_time AS TIME) AS claim_time
FROM alibis a
JOIN employees e 
    ON a.employee_id = e.employee_id
JOIN keycard_logs k
    ON a.employee_id = k.employee_id
    AND a.claim_time BETWEEN k.entry_time AND k.exit_time
ORDER BY e.employee_id, a.claim_time;


-- #4. Investigate suspicious calls made around the time

SELECT e1.name AS caller_name, e2.name AS receiver_name, c.call_time, c.duration_sec
FROM calls c
JOIN employees e1 ON c.caller_id = e1.employee_id
JOIN employees e2 ON c.receiver_id = e2.employee_id
WHERE c.call_time BETWEEN '2025-10-15 20:00:00' AND '2025-10-15 21:00:00';

-- #5. Match evidence with movements and claims

SELECT
    e.name,
    k.room AS actual_location,
    a.claimed_location,
    ev.room AS evidence_room,
    ev.description AS evidence_description,
    k.entry_time,
    k.exit_time,
    a.claim_time
FROM employees e
JOIN keycard_logs k ON e.employee_id = k.employee_id
JOIN alibis a ON e.employee_id = a.employee_id
JOIN evidence ev ON k.room = ev.room
WHERE k.room = 'CEO Office';

-- #6. Combine all findings to identify the killer

SELECT
    e.name AS employee_name,
    kl.room AS actual_location,
    a.claimed_location,
    ev.description AS evidence_description,
    kl.entry_time,
    kl.exit_time,
    a.claim_time
FROM employees e
JOIN keycard_logs kl 
    ON e.employee_id = kl.employee_id
JOIN alibis a 
    ON e.employee_id = a.employee_id
JOIN evidence ev 
    ON kl.room = ev.room
WHERE
    kl.room = 'CEO Office'
    AND kl.entry_time <= '2025-10-15 21:00:00'AND kl.exit_time >= '2025-10-15 21:00:00';
	
-- #THE KILLER.

SELECT DISTINCT(e.name) AS Killer
FROM employees e
JOIN keycard_logs k 
    ON e.employee_id = k.employee_id
JOIN alibis a 
    ON e.employee_id = a.employee_id
WHERE
    k.room = 'CEO Office'
    AND k.entry_time <= '2025-10-15 21:00:00'

    AND k.exit_time >= '2025-10-15 21:00:00';
