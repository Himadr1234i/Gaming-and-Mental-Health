-- Demographics & Platform

SELECT 
    gender,
    gaming_platform,
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13-18'
        WHEN age BETWEEN 19 AND 24 THEN '19-24'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '31+' 
    END AS age_group,
    COUNT(*) AS total_gamers
FROM gaming_and_mental_health
GROUP BY gender, gaming_platform, age_group
order by 1,2;

-- Sleep & Genre Analysis

SELECT 
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13-18'
        WHEN age BETWEEN 19 AND 24 THEN '19-24'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '31+' 
    END AS age_group,
    game_genre,
    CASE 
        WHEN sleep_hours < 3 THEN 'Insomnia'
        WHEN sleep_hours BETWEEN 3 AND 4 THEN 'Very Poor'
        WHEN sleep_hours > 4 AND sleep_hours <= 5.5 THEN 'Poor'
        WHEN sleep_hours > 5.5 AND sleep_hours <= 7 THEN 'Fair'
        WHEN sleep_hours > 7 THEN 'Good'
        ELSE 'Unknown'
    END AS sleep_status,
    sleep_disruption_frequency,
    mood_swing_frequency,
    COUNT(*) AS total_gamers,
    ROUND(AVG(daily_gaming_hours), 1) AS avg_daily_playtime,
    ROUND(AVG(sleep_hours), 1) AS avg_actual_sleep
FROM gaming_and_mental_health
GROUP BY 
    age_group, 
    game_genre, 
    sleep_status, 
    sleep_disruption_frequency, 
    mood_swing_frequency
order by 1;

-- Addiction & Lifestyle Risk

SELECT 
    gaming_addiction_risk_level,
    withdrawal_symptoms,
    loss_of_other_interests,
    continued_despite_problems,
    ROUND(AVG(daily_gaming_hours), 2) AS avg_daily_hours,
    ROUND(AVG(monthly_game_spending_usd), 2) AS avg_monthly_spending,
    ROUND(AVG(social_isolation_score), 2) AS avg_isolation_score,
    ROUND(AVG(exercise_hours_weekly), 2) AS avg_weekly_exercise,
    COUNT(*) AS total_gamers
FROM gaming_and_mental_health
GROUP BY gaming_addiction_risk_level, withdrawal_symptoms, loss_of_other_interests, continued_despite_problems;

-- Physical & Academic Performance

SELECT 
    gaming_addiction_risk_level,
    eye_strain,
    back_neck_pain,
    academic_work_performance,
    ROUND(AVG(grades_gpa), 2) AS avg_gpa,
    ROUND(AVG(work_productivity_score), 2) AS avg_work_score,
    ROUND(AVG(weight_change_kg), 2) AS avg_weight_gain_kg,
    COUNT(*) AS total_gamers
FROM gaming_and_mental_health
WHERE grades_gpa IS NOT NULL
GROUP BY gaming_addiction_risk_level, eye_strain, back_neck_pain, academic_work_performance;

-- Top 5 Risky Games

SELECT 
    primary_game, 
    COUNT(*) AS severe_risk_count
FROM gaming_and_mental_health
WHERE gaming_addiction_risk_level = 'Severe'
GROUP BY primary_game
ORDER BY severe_risk_count DESC
LIMIT 5;



SELECT 
    -- 1. Demographics
    record_id,
    gender,
    gaming_platform,
    CASE 
        WHEN age BETWEEN 13 AND 18 THEN '13-18'
        WHEN age BETWEEN 19 AND 24 THEN '19-24'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '31+' 
    END AS age_group,
    
    -- 2. Gaming & Genre
    game_genre,
    primary_game,
    daily_gaming_hours,
    
    -- 3. Sleep & Health (The Logic you built)
    CASE 
        WHEN sleep_hours < 3 THEN 'Insomnia'
        WHEN sleep_hours BETWEEN 3 AND 4 THEN 'Very Poor'
        WHEN sleep_hours > 4 AND sleep_hours <= 5.5 THEN 'Poor'
        WHEN sleep_hours > 5.5 AND sleep_hours <= 7 THEN 'Fair'
        WHEN sleep_hours > 7 THEN 'Good'
        ELSE 'Unknown'
    END AS sleep_status,
    sleep_hours,
    sleep_disruption_frequency,
    mood_swing_frequency,
    
    -- 4. Impact & Performance
    gaming_addiction_risk_level,
    academic_work_performance,
    grades_gpa,
    work_productivity_score,
    exercise_hours_weekly,
    social_isolation_score,
    
    -- 5. Physical Toll
    eye_strain,
    back_neck_pain,
    monthly_game_spending_usd

FROM gaming_and_mental_health;

