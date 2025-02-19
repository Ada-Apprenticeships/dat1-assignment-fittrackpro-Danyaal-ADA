-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer
 
SELECT ps.session_id,m.first_name || ' ' || m.last_name AS member_name,ps.session_date, ps.start_time,
       ps.end_time
FROM personal_training_sessions ps
JOIN members m
ON ps.member_id = m.member_id
JOIN staff st
ON ps.staff_id = st.staff_id
WHERE st.first_name = 'Ivy' AND st.last_name = 'Irwin'
ORDER BY ps.session_date, ps.start_time;
