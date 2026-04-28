select * from gaming_and_mental_health;
-- Count of Male and Female Gamers
select gender,Count(gender)
from gaming_and_mental_health
group by gender;

-- Count of Male and Female by platform
select gaming_platform, count(gender)
from gaming_and_mental_health
group by gaming_platform
order by count(gender) desc;  
-- Count of ages between 13 - 18, 19 - 24, 25 - 29, 30 - 35
SELECT 
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13 - 18'
        WHEN age BETWEEN 19 AND 24 THEN '19 - 24'
        WHEN age BETWEEN 25 AND 30 THEN '25 - 30'
        ELSE '31+' 
    END AS age_group,
    COUNT(*) AS total_users
FROM gaming_and_mental_health
GROUP BY age_group
ORDER BY MIN(age) ASC; 
-- Sleep quantity by age
SELECT 
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13 - 18'
        WHEN age BETWEEN 19 AND 24 THEN '19 - 24'
        WHEN age BETWEEN 25 AND 30 THEN '25 - 30'
        ELSE '31+' 
    END AS age_group,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep_quality,
    max(sleep_hours) as Maximum_sleep_quality,
    min(sleep_hours) as minimum_sleep_quality,
    COUNT(*) AS num_gamers 
FROM gaming_and_mental_health
GROUP BY age_group
ORDER BY MIN(age) ASC;

-- Quality of Sleep by age*

SELECT 
    -- 1. Create the Age Groups
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13-18'
        WHEN age BETWEEN 19 AND 24 THEN '19-24'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '31+' 
    END AS age_group,
    
    -- 2. Create the Sleep Status Categories
    CASE 
        WHEN sleep_hours < 3 THEN 'Insomnia'
        WHEN sleep_hours BETWEEN 3 AND 4 THEN 'Very Poor'
        WHEN sleep_hours > 4 AND sleep_hours <= 5.5 THEN 'Poor'
        WHEN sleep_hours > 5.5 AND sleep_hours <= 7 THEN 'Fair'
        WHEN sleep_hours > 7 THEN 'Good'
        ELSE 'Unknown'
    END AS sleep_status,
    
    -- 3. The Math
    COUNT(*) AS total_gamers,
    ROUND(AVG(age), 1) AS avg_exact_age
    
FROM gaming_and_mental_health
GROUP BY age_group, sleep_status
ORDER BY MIN(age) , 
    CASE 
        WHEN sleep_status = 'Insomnia' THEN 1
        WHEN sleep_status = 'Very Poor' THEN 2
        WHEN sleep_status = 'Poor' THEN 3
        WHEN sleep_status = 'Fair' THEN 4
        WHEN sleep_status = 'Good' THEN 5
    END ASC;

-- Sleep quality with their age and the games they play**

SELECT 
    -- 1. Age Grouping
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13-18'
        WHEN age BETWEEN 19 AND 24 THEN '19-24'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '31+' 
    END AS age_group,
    
    -- 2. Genre
    game_genre,
    
    
    CASE 
        WHEN sleep_hours < 3 THEN 'Insomnia'
        WHEN sleep_hours BETWEEN 3 AND 4 THEN 'Very Poor'
        WHEN sleep_hours > 4 AND sleep_hours <= 5.5 THEN 'Poor'
        WHEN sleep_hours > 5.5 AND sleep_hours <= 7 THEN 'Fair'
        WHEN sleep_hours > 7 THEN 'Good'
        ELSE 'Unknown'
    END AS sleep_status,
    
    -- 4. Analytics
    COUNT(*) AS total_gamers,
    ROUND(AVG(daily_gaming_hours), 1) AS avg_daily_playtime,
    round(avg(sleep_hours),1) as avg_sleep_hours
    
FROM gaming_and_mental_health
GROUP BY age_group, game_genre, sleep_status
-- 5. The Filter: Only show significant trends
HAVING COUNT(*) > 5 
ORDER BY total_gamers DESC;

-- compare sleep quality across the entire gamer base using the corrected platforms

SELECT 
    gaming_platform,
    AVG(sleep_hours) AS avg_hours,
    -- Percentage of 'Good' Sleep
    ROUND(SUM(CASE WHEN sleep_quality = 'Good' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_good_sleep,
    -- Percentage of 'Very Poor' Sleep
    ROUND(SUM(CASE WHEN sleep_quality = 'Very Poor' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_very_poor_sleep
FROM gaming_and_mental_health
GROUP BY gaming_platform;

-- Sleep disruption frequency with age
SELECT 
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13-18'
        WHEN age BETWEEN 19 AND 24 THEN '19-24'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '31+' 
    END AS age_group,
    COUNT(*) AS total_gamers,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep_hours,
    ROUND(SUM(CASE WHEN sleep_disruption_frequency IN ('Often', 'Always') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_high_disruption
FROM gaming_and_mental_health
GROUP BY age_group
ORDER BY MIN(age) ASC;

-- now with gender 
SELECT 
    gender,
    COUNT(*) AS total_gamers,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep_hours,
    -- Percentage of people reporting 'Often' or 'Always'
    ROUND(SUM(CASE WHEN sleep_disruption_frequency IN ('Often', 'Always') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_high_disruption
FROM gaming_and_mental_health
GROUP BY gender
ORDER BY total_gamers DESC;

-- Now based age-gender 
SELECT 
    gender,
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13-18'
        WHEN age BETWEEN 19 AND 24 THEN '19-24'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '31+' 
    END AS age_group,
    COUNT(*) AS total_gamers,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep_hours,
    ROUND(SUM(CASE WHEN sleep_disruption_frequency IN ('Often', 'Always') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_high_disruption
FROM gaming_and_mental_health
WHERE gender IN ('Male', 'Female')
GROUP BY gender, age_group
ORDER BY gender, MIN(age) ASC;
 
 -- Connection between sleep disruption with gaming addiction 
SELECT 
    gender,
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13-18'
        WHEN age BETWEEN 19 AND 24 THEN '19-24'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '31+' 
    END AS age_group,
    COUNT(*) AS total_gamers,
    -- Calculate percentage of 'Severe' risk
    ROUND(SUM(CASE WHEN gaming_addiction_risk_level = 'Severe' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_severe_risk,
    -- Numeric average (1: Low, 4: Severe)
    ROUND(AVG(CASE 
        WHEN gaming_addiction_risk_level = 'Low' THEN 1
        WHEN gaming_addiction_risk_level = 'Moderate' THEN 2
        WHEN gaming_addiction_risk_level = 'High' THEN 3
        WHEN gaming_addiction_risk_level = 'Severe' THEN 4
    END), 2) AS avg_risk_score
FROM gaming_and_mental_health
WHERE gender IN ('Male', 'Female')
GROUP BY gender, age_group
ORDER BY gender, MIN(age) ASC;

-- Connection between sleep,addiction, and academin grade

SELECT 
    CASE WHEN sleep_hours < 5 THEN 'Low Sleep' ELSE 'Normal Sleep' END AS sleep_group,
    CASE WHEN gaming_addiction_risk_level IN ('High', 'Severe') THEN 'High Risk' ELSE 'Low Risk' END AS addiction_group,
    academic_work_performance,
    COUNT(*) AS student_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY 
        CASE WHEN sleep_hours < 5 THEN 'Low Sleep' ELSE 'Normal Sleep' END,
        CASE WHEN gaming_addiction_risk_level IN ('High', 'Severe') THEN 'High Risk' ELSE 'Low Risk' END
    ), 2) AS percentage_of_group
FROM gaming_and_mental_health
GROUP BY sleep_group, addiction_group, academic_work_performance
ORDER BY sleep_group, addiction_group, percentage_of_group DESC;

-- Connection of less sleep with mood swing
SELECT 
    CASE 
        WHEN sleep_hours < 5 THEN 'Sleep Less (<5h)'
        WHEN sleep_hours BETWEEN 5 AND 7 THEN 'Moderate Sleep (5-7h)'
        ELSE 'High Sleep (>7h)' 
    END AS sleep_group,
    COUNT(*) AS total_gamers,
    -- Percentage of people reporting 'Daily' mood swings
    ROUND(SUM(CASE WHEN mood_swing_frequency = 'Daily' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_daily_mood_swings
FROM gaming_and_mental_health
GROUP BY sleep_group
ORDER BY pct_daily_mood_swings DESC;

-- Compare of sleep with mood swings and with Withdrawal symptoms
SELECT 
    CASE 
        WHEN sleep_hours < 5 THEN 'Low Sleep (<5h)'
        WHEN sleep_hours BETWEEN 5 AND 7 THEN 'Moderate Sleep (5-7h)'
        ELSE 'High Sleep (>7h)' 
    END AS sleep_group,
    withdrawal_symptoms,
    mood_swing_frequency,
    COUNT(*) AS gamer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY 
        CASE 
            WHEN sleep_hours < 5 THEN 'Low Sleep (<5h)'
            WHEN sleep_hours BETWEEN 5 AND 7 THEN 'Moderate Sleep (5-7h)'
            ELSE 'High Sleep (>7h)' 
        END), 2) AS pct_of_sleep_group
FROM gaming_and_mental_health
GROUP BY sleep_group, withdrawal_symptoms, mood_swing_frequency
ORDER BY sleep_group, withdrawal_symptoms, gamer_count DESC;


-- The Financial & Lifestyle Impact

SELECT 
    gaming_addiction_risk_level,
    ROUND(AVG(daily_gaming_hours), 2) AS avg_daily_hours,
    ROUND(AVG(monthly_game_spending_usd), 2) AS avg_monthly_spending,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep_hours,
    ROUND(AVG(social_isolation_score), 2) AS avg_isolation_score,
    ROUND(AVG(exercise_hours_weekly), 2) AS avg_weekly_exercise
FROM gaming_and_mental_health
GROUP BY gaming_addiction_risk_level
ORDER BY 
    CASE 
        WHEN gaming_addiction_risk_level = 'Low' THEN 1
        WHEN gaming_addiction_risk_level = 'Moderate' THEN 2
        WHEN gaming_addiction_risk_level = 'High' THEN 3
        WHEN gaming_addiction_risk_level = 'Severe' THEN 4
    END;

-- The "Warning Sign": Withdrawal Symptoms

SELECT 
    gaming_addiction_risk_level,
    COUNT(*) AS total_gamers,
    SUM(CASE WHEN withdrawal_symptoms = 'TRUE' THEN 1 ELSE 0 END) AS count_with_symptoms,
    ROUND(SUM(CASE WHEN withdrawal_symptoms = 'TRUE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_withdrawal_symptoms
FROM gaming_and_mental_health
GROUP BY gaming_addiction_risk_level
ORDER BY pct_withdrawal_symptoms DESC;

-- High-Risk Games & Platforms

SELECT 
    primary_game, 
    COUNT(*) AS severe_risk_count
FROM gaming_and_mental_health
WHERE gaming_addiction_risk_level = 'Severe'
GROUP BY primary_game
ORDER BY severe_risk_count DESC
LIMIT 5;

-- Platform Distribution for Severe Risk 

SELECT 
    gaming_platform, 
    COUNT(*) AS severe_risk_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM gaming_and_mental_health WHERE gaming_addiction_risk_level = 'Severe'), 2) AS pct_of_severe_total
FROM gaming_and_mental_health
WHERE gaming_addiction_risk_level = 'Severe'
GROUP BY gaming_platform
ORDER BY severe_risk_count DESC;

-- Genre Risk Heatmap Data

SELECT 
    game_genre,
    COUNT(CASE WHEN gaming_addiction_risk_level = 'Low' THEN 1 END) AS low_risk,
    COUNT(CASE WHEN gaming_addiction_risk_level = 'Moderate' THEN 1 END) AS moderate_risk,
    COUNT(CASE WHEN gaming_addiction_risk_level = 'High' THEN 1 END) AS high_risk,
    COUNT(CASE WHEN gaming_addiction_risk_level = 'Severe' THEN 1 END) AS severe_risk
FROM gaming_and_mental_health
GROUP BY game_genre
ORDER BY severe_risk DESC;

-- The "Clinical Indicators"

SELECT 
    gaming_addiction_risk_level,
    ROUND(AVG(CASE WHEN loss_of_other_interests = 'TRUE' THEN 1 ELSE 0 END) * 100, 1) AS pct_lost_other_interests,
    ROUND(AVG(CASE WHEN continued_despite_problems = 'TRUE' THEN 1 ELSE 0 END) * 100, 1) AS pct_continued_despite_problems
FROM gaming_and_mental_health
GROUP BY gaming_addiction_risk_level
ORDER BY pct_continued_despite_problems DESC;

-- The Physical Toll

SELECT 
    gaming_addiction_risk_level,
    ROUND(AVG(CASE WHEN eye_strain = 'TRUE' THEN 1 ELSE 0 END) * 100, 1) AS pct_eye_strain,
    ROUND(AVG(CASE WHEN back_neck_pain = 'TRUE' THEN 1 ELSE 0 END) * 100, 1) AS pct_back_neck_pain,
    ROUND(AVG(weight_change_kg), 2) AS avg_weight_gain_kg
FROM gaming_and_mental_health
GROUP BY gaming_addiction_risk_level;

-- The "Functioning Addict" Myth

SELECT 
    gaming_addiction_risk_level,
    ROUND(AVG(grades_gpa), 2) AS avg_gpa,
    ROUND(AVG(work_productivity_score), 2) AS avg_work_score
FROM gaming_and_mental_health
WHERE grades_gpa IS NOT NULL -- Cleaning nulls for accuracy
GROUP BY gaming_addiction_risk_level;




























































































