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
LIMIT 25