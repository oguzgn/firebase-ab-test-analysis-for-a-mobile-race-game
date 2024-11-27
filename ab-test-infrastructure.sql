WITH abtest_info AS (
  SELECT
    event_date,
    user_id,
    platform,
    geo.country AS country,
    geo.sub_continent AS sub_continent,
    (SELECT value.int_value 
     FROM UNNEST(event_params) 
     WHERE key = 'ga_session_id') AS ga_session_id,
    (SELECT value.string_value 
     FROM UNNEST(event_params) 
     WHERE key = 'abtest_group') AS abtest_group,
    (SELECT value.string_value 
     FROM UNNEST(event_params) 
     WHERE key = 'abtest_name') AS abtest_name 
  FROM
    `a_race_game.dataset.events`
  WHERE
    event_name = 'abtest_start'
    AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'abtest_name') IS NOT NULL -- Herhangi bir abtest için
)
SELECT
  abtest_info.event_date,
  abtest_info.abtest_name,
  abtest_info.abtest_group,
  abtest_info.platform,
  abtest_info.country,
  abtest_info.sub_continent,
  COUNT(DISTINCT abtest_info.user_id) AS unique_users,
  COUNTIF(event_name = 'session_start') AS sessions_started,
  COUNTIF(event_name = 'race_start') AS round_started,
  COUNTIF(event_name = 'race_complete') AS round_completed,
  COUNTIF(event_name = 'select_map') AS map_selected,
  COUNTIF(event_name = 'select_car') AS car_selected,
  COUNTIF(event_name = 'race_start' 
          AND (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'round') IN (1, 0)) AS races_started,
  COUNTIF(event_name = 'race_complete' 
          AND (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'race_result') IS NOT NULL) AS races_completed,
  COUNTIF(event_name = 'race_complete' 
          AND (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'race_result') = 1) AS races_won,
  SUM(CASE WHEN event_name = 'currency_earn' 
           AND (SELECT value.string_value FROM UNNEST(event_params) 
                WHERE key = 'currency_type') = 'cash' 
           THEN (SELECT value.int_value FROM UNNEST(event_params) 
                 WHERE key = 'amount') 
       END) AS cash_earn,
  SUM(CASE WHEN event_name = 'currency_earn' 
           AND (SELECT value.string_value FROM UNNEST(event_params) 
                WHERE key = 'currency_type') LIKE '%chest%' 
           THEN (SELECT value.int_value FROM UNNEST(event_params) 
                 WHERE key = 'amount') 
       END) AS chest_earn,
  SUM(CASE WHEN event_name = 'currency_earn' 
           AND (SELECT value.string_value FROM UNNEST(event_params) 
                WHERE key = 'currency_type') = 'trophy' 
           THEN (SELECT value.int_value FROM UNNEST(event_params) 
                 WHERE key = 'amount') 
       END) AS trophy_earn,
  SUM(CASE WHEN event_name = 'currency_earn' 
           AND (SELECT value.string_value FROM UNNEST(event_params) 
                WHERE key = 'currency_type') NOT IN ('cash', 'trophy') 
           AND (SELECT value.string_value FROM UNNEST(event_params) 
                WHERE key = 'currency_type') NOT LIKE '%chest%' 
           THEN (SELECT value.int_value FROM UNNEST(event_params) 
                 WHERE key = 'amount') 
       END) AS car_earn,
  SUM(CASE WHEN event_name = 'currency_spend' 
           AND (SELECT value.string_value FROM UNNEST(event_params) 
                WHERE key = 'currency_type') = 'cash' 
           THEN (SELECT value.int_value FROM UNNEST(event_params) 
                 WHERE key = 'amount') 
       END) AS cash_spend,  
  SUM(CASE WHEN event_name = 'currency_spend' 
           AND (SELECT value.string_value FROM UNNEST(event_params) 
                WHERE key = 'currency_type') = 'trophy' 
           THEN (SELECT value.int_value FROM UNNEST(event_params) 
                 WHERE key = 'amount') 
       END) AS trophy_spend,
  COUNTIF(event_name = 'car_level_up') AS cars_upgraded,
  COUNTIF(event_name = 'map_unlock') AS map_unlocked,
  SUM((SELECT value.int_value FROM UNNEST(event_params) 
       WHERE key = 'engagement_time_msec')) / 1000 AS total_engagement_seconds,
  COUNTIF(event_name = 'app_exception') AS app_exception,
  COUNTIF(event_name = 'app_remove') AS app_removed,
  AVG(CASE 
          WHEN event_name = 'stats_fps' 
          AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'current_mode') = 'Menu Scene'
          THEN (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'avg_fps') 
      END) AS avg_menu_fps,
  AVG(CASE 
          WHEN event_name = 'stats_fps' 
          AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'current_mode') = 'Game Scene'
          THEN (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'avg_fps') 
      END) AS avg_game_fps,
  SUM(CASE 
          WHEN event_name = 'stats_critical_fps' 
          AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'current_mode') = 'Menu Scene'
          THEN (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'critical_fps_count') 
      END) AS menu_critical_fps_count,
  SUM(CASE 
          WHEN event_name = 'stats_critical_fps' 
          AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'current_mode') = 'Game Scene'
          THEN (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'critical_fps_count') 
      END) AS game_critical_fps_count ,
      COUNTIF(event_name = 'ad_impression' 
          AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'currency') = 'USD'
           AND(SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value') < 1) AS ad_imp_count,
      SUM(CASE 
          WHEN event_name = 'ad_impression' 
          AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'currency') = 'USD'
          AND(SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value') < 1
          THEN (SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value') 
      END) AS ad_imp_usd ,   
FROM
  `a_race_game.dataset.events` events
INNER JOIN
  abtest_info
ON
  (SELECT value.int_value FROM UNNEST(events.event_params) WHERE key = 'ga_session_id') = abtest_info.ga_session_id
GROUP BY
  abtest_info.abtest_group,
  abtest_info.event_date,
  abtest_info.platform,
  abtest_info.country,
  abtest_info.sub_continent,
  abtest_info.abtest_name 
