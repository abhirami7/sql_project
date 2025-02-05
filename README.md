# Introduction
This project explores the data job market, focusing specifically on Data Analyst roles. It analyzes the top-paying jobs, identifies the most in-demand skills, and highlights the highest-paying skills. Furthermore, it uncovers the optimal skills to learn for thriving in the data industry.

Check out the SQL queries here: [project_sql folder](/project_sql/)

 In this analysis, I aimed to answer the following key questions about the data job market:
 1. What are the top-paying Data Analyst jobs?
 2. What are the skills required for the top-paying jobs?
 3. What are the most in-demand skills that recruiters are looking for?
 4. What are the highest paying skills?
 5. What are the optimal skills to learn for anyone looking to enter the data job market?  

# Tools I used
For this project, I utilized the following tools:
- SQL: To query and analyze the data.
- PostgreSQL: The Database Management Systsem used used to manage and interact with the data.
- VSCode: The code editor used for writing SQL and managing the project files.
- Git & Github: For version control.

# The Analysis
### 1. Top paying Data Analyst jobs:
The following query identifies the top-paying Data Analyst positions by filtering job postings based on the average yearly salary, showing the job title, company name, and location for remote positions.

```sql
SELECT job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    company_dim.name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON
    company_dim.company_id = job_postings_fact.company_id
WHERE job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10;
```
#### Insights - 
The highest-paying Data Analyst roles are concentrated in companies that offer remote work or flexible job locations. This suggests that businesses are willing to provide competitive salaries to attract top talent for these positions. |

### 2. Skills for Top Paying jobs
This query fetches the specific skills required for the top 10 highest-paying Data Analyst jobs. It joins the job postings with the skills table to reveal which skills are linked to the best-paying positions.

```sql
WITH top_paying_jobs AS (
SELECT job_id,
    job_title,
    salary_year_avg,
    company_dim.name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON
    company_dim.company_id = job_postings_fact.company_id
WHERE job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10
)

SELECT top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON 
    skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY salary_year_avg DESC;
```
#### Insights - 
The skills required for top-paying jobs include SQL, data visualization tools like Tableau and Power BI, and programming languages such as Python and R, which are essential for higher-paying roles.

### 3. Top Demanded Skills
This query shows the most frequently requested skills across all Data Analyst job postings. It helps identify which skills employers are seeking most in this role.

```sql
SELECT skills,
    COUNT (skills_job_dim.job_id) AS skills_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON 
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON 
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY skills_count DESC
LIMIT 6;
```
#### Insights - 
Skills like SQL, Excel, Python and Tableau are the most frequently requested in job descriptions, indicating that these are essential for aspiring Data Analysts to learn.

### 4. Highest paying skills
This query ranks the skills by their associated average salary, revealing which technical competencies lead to higher-paying jobs.

```sql
SELECT skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON 
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON 
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 20;
```
#### Insights -
Advanced technical skills such as machine learning, statistical modeling, and programming lead to the highest salaries in Data Analyst roles. 

### 5. The optimals skills to learn
This query analyzes the balance between the most demanded and highest-paying skills, revealing the most optimal skills to learn. It combines skill demand with salary information to suggest optimal learning paths.

```sql
WITH skill_demand AS (
SELECT skills_dim.skill_id,
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS skills_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON 
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON 
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id, skills_dim.skills
), avg_salary AS (
SELECT skills_job_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(salary_year_avg),0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON 
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON 
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY skills_job_dim.skill_id, skills_dim.skills
)

SELECT skill_demand.skill_id,
    skill_demand.skills,
    skills_count,
    average_salary
FROM skill_demand
INNER JOIN avg_salary ON
    skill_demand.skill_id = avg_salary.skill_id
WHERE skills_count > 10
ORDER BY skills_count DESC, average_salary DESC
LIMIT 25;
```
#### Insights - 
This query highlights that SQL, Excel, Python, and data visualization skills are not only highly demanded but also well-compensated, making them optimal choices for professionals looking to excel in the data analytics field.

# Conclusions
### Insights 
 - Top-paying jobs: The most lucrative Data Analyst roles often offer flexible, remote work arrangements and require mastery of advanced data analytics skills.
 - Top-demanded skills: SQL, Python, and Excel are consistently in demand, suggesting they are fundamental for anyone entering this field.
 - Highest-paying skills: Programming, statistical analysis, and machine learning are among the highest-paying skill sets for Data Analysts.
 - Optimal skills to learn: To maximize both employability and earning potential, focusing on SQL, Python, and data visualization tools like Tableau and Power BI is highly recommended.

### Closing thoughts 
This project gave me the opportunity to deepen my knowledge of data analytics while honing my SQL skills. It provided hands-on experience with querying databases and analyzing real-world data, also helped me understand how to structure and analyze datasets effectively. Additionally, I improved my understanding of the job landscape for Data Analysts, including which skills are most in-demand and which technical competencies lead to the highest-paying roles.