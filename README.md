# 🏥 Hospital Healthcare Management Analytics Portfolio

Welcome to the Hospital Healthcare Management Analytics repository! This project features a comprehensive **Power BI dashboard**, a robust **relational SQL database backend**, and deep-dive **analytical queries** designed to optimize hospital operations, patient care quality, and financial performance.

---

## 📊 Dashboard Overview

The Power BI solution consists of interactive views tracking key operational, clinical, and financial metrics across the facility. 

### 1. Hospital View
*Focuses on high-level operational efficiency, revenue distribution, department workloads, and patient satisfaction.*

![Hospital View](images/hospital_view.png)

* **Key Performance Indicators (KPIs):** Tracks **2,506** total patients (**1,679** inpatients, **827** outpatients), **262** total staff, an average treatment cost of **$161.41**, an average ER wait time of **65.63 minutes**, and a patient-to-staff ratio of **0.10**.
* **Occupied Bed %:** Visualizes bed capacity utilization at **62%** (**2,847** beds total).
* **Departmental Performance:** Evaluates average ER wait times by department (highlighting outliers like OPD Outpatient and Oncology) alongside total revenue breakdowns by age group.
* **Patient Feedback & Ratings:** Measures treatment understandability feedback and overall ratings across age demographics.

### 2. Patient View
*Focuses on patient demographics, length of stay (LOS), admission statuses, and departmental inpatient distributions.*

![Patient View](images/patient_view.png)

* **Clinical Flow KPIs:** Monitors **1,679** admissions, **209** discharges, an average length of stay (LOS) of **1.70 days**, **82** ICU cases, and **86** recorded deaths.
* **Demographics & Geography:** Displays gender distributions (**51.08% Male, 48.92% Female**) and geographical patient distribution maps across North America.
* **LOS Breakdown:** Analyzes patient volume by length of stay brackets, showing that the majority of stays range between 1–2 days.

---

## 🗄️ Database & SQL Backend

The project uses a structured relational database (`hospital_db`) with automated step-by-step query scripts for data integrity and advanced metric reporting:

* **Dashboard & KPI Queries:** Extracts real-time aggregations for inpatient/outpatient weekly trends, departmental wait times, and satisfaction scores.
* **Insight Queries:** Computes advanced metrics beyond the standard UI, including:
  * Month-over-month revenue growth.
  * Department scorecards with mortality/readmission tracking.
  * Multi-variable patient type comparisons.

---

## 🛠️ Tech Stack
* **Data Visualization:** Power BI Desktop
* **Database:** SQL (Relational Database)
* **Data Processing:** DAX & SQL Queries

---
*Feel free to explore the repository, review the SQL scripts, and interact with the dashboard files!*
