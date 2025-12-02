🕵️ SQL Murder Mystery Investigation

A Capstone Project by Indian Data Club

This project is a detective-style SQL investigation challenge where the goal is to identify the murderer by analyzing employees’ movements, digital footprints, keycard logs, alibis, calls, and evidence records.
The entire case takes place inside a corporate office on 15 October 2025, and SQL is used to uncover inconsistencies and pinpoint the culprit.

📁 Project Files

Technova Database – Table creation + dataset
Murder Mystery Analysis.sql – SQL queries used for the investigation
README.md – Project explanation 

📊 Dataset Overview
This project uses five tables:

1. employees

Stores details like name, department, and role.
Key columns: employee_id, name, department, role

2. keycard_logs

Tracks movement of employees through secure rooms.
Key columns: room, entry_time, exit_time

3. calls

Records calls made between employees.
Key columns: caller_id, receiver_id, call_time

4. alibis

Stores self-reported locations of employees at the time of the crime.
Key columns: claimed_location, claim_time

5. evidence

Contains physical evidence found at the crime scene.
Key columns: room, description, found_time

All data is synthetic and created solely for SQL analysis.

🕵️ Case Summary

On 15 Oct 2025 at 21:00, an incident occurred in the CEO Office.
The challenge is to:

Identify the crime scene

Analyze keycard access

Verify alibis

Review phone call patterns

Match movements with evidence

Identify the killer
