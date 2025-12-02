-- DROP TABLES if exist
DROP TABLE IF EXISTS employees, keycard_logs, calls, alibis, evidence;

-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    role VARCHAR(50)
);

INSERT INTO employees VALUES
(1, 'Alice Johnson', 'Engineering', 'Software Engineer'),
(2, 'Bob Smith', 'HR', 'HR Manager'),
(3, 'Clara Lee', 'Finance', 'Accountant'),
(4, 'David Kumar', 'Engineering', 'DevOps Engineer'),
(5, 'Eva Brown', 'Marketing', 'Marketing Lead'),
(6, 'Frank Li', 'Engineering', 'QA Engineer'),
(7, 'Grace Tan', 'Finance', 'CFO'),
(8, 'Henry Wu', 'Engineering', 'CTO'),
(9, 'Isla Patel', 'Support', 'Customer Support'),
(10, 'Jack Chen', 'HR', 'Recruiter');

-- Keycard Logs Table
CREATE TABLE keycard_logs (
    log_id INT PRIMARY KEY,
    employee_id INT,
    room VARCHAR(50),
    entry_time TIMESTAMP,
    exit_time TIMESTAMP
);

INSERT INTO keycard_logs VALUES
(1, 1, 'Office', '2025-10-15 08:00', '2025-10-15 12:00'),
(2, 2, 'HR Office', '2025-10-15 08:30', '2025-10-15 17:00'),
(3, 3, 'Finance Office', '2025-10-15 08:45', '2025-10-15 12:30'),
(4, 4, 'Server Room', '2025-10-15 08:50', '2025-10-15 09:10'),
(5, 5, 'Marketing Office', '2025-10-15 09:00', '2025-10-15 17:30'),
(6, 6, 'Office', '2025-10-15 08:30', '2025-10-15 12:30'),
(7, 7, 'Finance Office', '2025-10-15 08:00', '2025-10-15 18:00'),
(8, 8, 'Server Room', '2025-10-15 08:40', '2025-10-15 09:05'),
(9, 9, 'Support Office', '2025-10-15 08:30', '2025-10-15 16:30'),
(10, 10, 'HR Office', '2025-10-15 09:00', '2025-10-15 17:00'),
(11, 4, 'CEO Office', '2025-10-15 20:50', '2025-10-15 21:00'); -- killer

-- Calls Table
CREATE TABLE calls (
    call_id INT PRIMARY KEY,
    caller_id INT,
    receiver_id INT,
    call_time TIMESTAMP,
    duration_sec INT
);

INSERT INTO calls VALUES
(1, 4, 1, '2025-10-15 20:55', 45),
(2, 5, 1, '2025-10-15 19:30', 120),
(3, 3, 7, '2025-10-15 14:00', 60),
(4, 2, 10, '2025-10-15 16:30', 30),
(5, 4, 7, '2025-10-15 20:40', 90);

-- Alibis Table
CREATE TABLE alibis (
    alibi_id INT PRIMARY KEY,
    employee_id INT,
    claimed_location VARCHAR(50),
    claim_time TIMESTAMP
);

INSERT INTO alibis VALUES
(1, 1, 'Office', '2025-10-15 20:50'),
(2, 4, 'Server Room', '2025-10-15 20:50'), -- false alibi
(3, 5, 'Marketing Office', '2025-10-15 20:50'),
(4, 6, 'Office', '2025-10-15 20:50');

-- Evidence Table
CREATE TABLE evidence (
    evidence_id INT PRIMARY KEY,
    room VARCHAR(50),
    description VARCHAR(255),
    found_time TIMESTAMP
);

INSERT INTO evidence VALUES
(1, 'CEO Office', 'Fingerprint on desk', '2025-10-15 21:05'),
(2, 'CEO Office', 'Keycard swipe logs mismatch', '2025-10-15 21:10'),
(3, 'Server Room', 'Unusual access pattern', '2025-10-15 21:15');

SELECT * FROM evidence;

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