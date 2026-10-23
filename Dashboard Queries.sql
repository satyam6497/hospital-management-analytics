/* ======================================================================
   HOSPITAL DB – STEP 2: dashboard queries + insight queries
   Run AFTER 01_build_database.sql. Run one query at a time
   (click inside it, then Ctrl+Enter in Workbench).
   ====================================================================== */
USE hospital_db;

/* 1. DATA CHECKS ---------------------------------------------------- */
SELECT COUNT(*) AS rows_loaded, COUNT(DISTINCT patient_id) AS unique_ids FROM patients;       -- 2506 / 2506
SELECT SUM(bed_id IS NULL) AS no_bed, SUM(er_time IS NULL) AS no_er_time FROM patients;        -- 755 / 719

/* 2. DASHBOARD QUERIES --------------------------------------------- */
-- KPI cards
SELECT COUNT(*)                         AS total_patients,
       SUM(patient_type = 'Inpatient')  AS inpatients,
       SUM(patient_type = 'Outpatient') AS outpatients,
       (SELECT COUNT(*) FROM staff)     AS total_staff,
       ROUND(AVG(treatment_cost), 2)    AS avg_treatment_cost,
       ROUND(AVG(er_time), 2)           AS avg_er_wait,
       ROUND((SELECT COUNT(*) FROM staff) / COUNT(*), 2) AS patient_staff_ratio
FROM patients;

-- Occupied bed % (62%)
SELECT ROUND(100 * COUNT(bed_id) / (SELECT COUNT(*) FROM beds), 1) AS occupied_bed_pct FROM patients;

-- Weekly inpatient vs outpatient
-- WEEK(date, 0) + 1 reproduces Power BI's week numbers (W9, W10, W12 ... match the dashboard)
SELECT WEEK(visit_date, 0) + 1 AS week_no,
       SUM(patient_type = 'Inpatient')  AS inpatients,
       SUM(patient_type = 'Outpatient') AS outpatients
FROM patients GROUP BY week_no ORDER BY week_no;

-- Revenue by age group
SELECT age_bucket, ROUND(SUM(treatment_cost), 2) AS total_revenue
FROM patients GROUP BY age_bucket ORDER BY total_revenue DESC;

-- Avg ER time by department
SELECT d.department_name, ROUND(AVG(p.er_time), 0) AS avg_er_time
FROM patients p JOIN departments d ON d.dpt_id = p.dpt_id
GROUP BY d.department_name ORDER BY avg_er_time DESC;

-- Rating by age group
SELECT age_bucket, ROUND(AVG(rating), 2) AS avg_rating FROM patients GROUP BY age_bucket;

-- Patient satisfaction (sentiment) and doctor-explanation feedback
SELECT sentiment, COUNT(*) AS patients FROM patients GROUP BY sentiment;
SELECT feedback,  COUNT(*) AS patients FROM patients GROUP BY feedback ORDER BY patients DESC;

-- Patient page KPIs: admitted, discharged, avg LOS, ICU, deaths
SELECT SUM(patient_type = 'Inpatient') AS admitted,
       SUM(status = 'Discharge')       AS discharged,
       ROUND(AVG(los), 2)              AS avg_los,
       SUM(status = 'ICU')             AS icu,
       SUM(status = 'Death')           AS deaths
FROM patients;

-- Gender split, avg LOS by age group, patients by age group
SELECT gender, COUNT(*) AS patients FROM patients GROUP BY gender;
SELECT age_bucket, ROUND(AVG(los), 2) AS avg_los, COUNT(*) AS patients FROM patients GROUP BY age_bucket;

-- Inpatients by department and status
SELECT d.department_name, p.status, COUNT(*) AS in_patient
FROM patients p JOIN departments d ON d.dpt_id = p.dpt_id
WHERE p.patient_type = 'Inpatient'
GROUP BY d.department_name, p.status;

-- Length-of-stay breakdown
SELECT los_bucket, COUNT(*) AS patients FROM patients
WHERE los_bucket IS NOT NULL GROUP BY los_bucket ORDER BY patients DESC;

/* 3. INSIGHT QUERIES (beyond the dashboard) ------------------------- */
-- A. Monthly revenue with month-over-month growth
WITH monthly AS (
    SELECT DATE_FORMAT(visit_date, '%Y-%m') AS ym, SUM(treatment_cost) AS revenue
    FROM patients GROUP BY ym
)
SELECT ym, ROUND(revenue, 2) AS revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY ym)) / LAG(revenue) OVER (ORDER BY ym), 1) AS mom_growth_pct
FROM monthly ORDER BY ym;

-- B. Department scorecard
SELECT d.department_name,
       COUNT(*)                                             AS patients,
       ROUND(SUM(p.treatment_cost), 0)                      AS revenue,
       ROUND(AVG(p.er_time), 1)                             AS avg_er_wait,
       ROUND(AVG(p.rating), 2)                              AS avg_rating,
       ROUND(100 * SUM(p.status = 'Death')   / COUNT(*), 2) AS mortality_pct,
       ROUND(100 * SUM(p.status = 'Readmit') / COUNT(*), 2) AS readmission_pct,
       RANK() OVER (ORDER BY SUM(p.treatment_cost) DESC)    AS revenue_rank
FROM patients p JOIN departments d ON d.dpt_id = p.dpt_id
GROUP BY d.department_name ORDER BY revenue_rank;

-- C. Inpatient vs outpatient
SELECT patient_type, COUNT(*) AS patients,
       ROUND(AVG(treatment_cost), 2) AS avg_cost,
       ROUND(AVG(er_time), 1)        AS avg_er_wait,
       ROUND(AVG(los), 2)            AS avg_los,
       ROUND(AVG(rating), 2)         AS avg_rating
FROM patients GROUP BY patient_type;

-- D. Departments with ER wait above the hospital average
SELECT d.department_name, ROUND(AVG(p.er_time), 1) AS avg_er_wait
FROM patients p JOIN departments d ON d.dpt_id = p.dpt_id
GROUP BY d.department_name
HAVING AVG(p.er_time) > (SELECT AVG(er_time) FROM patients)
ORDER BY avg_er_wait DESC;