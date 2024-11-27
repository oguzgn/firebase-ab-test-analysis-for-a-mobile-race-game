# **A/B Test Analysis with Event-Based Data**

This repository provides an infrastructure for analyzing A/B tests conducted in mobile games. It leverages **BigQuery** to process event-based datasets from **Firebase** and **GA4** and visualizes the results through **Looker Studio** dashboards. The project is designed to help game developers and analysts dynamically compare A/B test outcomes using event-driven data.

---

## **Key Features**

- **Event-Based Analysis**: Processes event-driven data to extract meaningful insights about user behavior and game performance.
- **BigQuery SQL Queries**:  
  - Includes a comprehensive query that aggregates key metrics such as user engagement, game progression, and monetization performance.
  - Specifically tracks A/B test-related metrics using attributes like `abtest_name` and `abtest_group`.
- **Looker Studio Integration**:  
  - Displays the query results through an interactive dashboard that supports filtering by date, platform, and region.

---

## **How It Works**

### **Input Dataset**
The data is sourced from Firebase/GA4 and includes various game-related events:
- **Session Events**: `session_start`, `session_end`
- **Game Events**: `race_start`, `race_complete`, `select_map`, `select_car`
- **Monetization Events**: `currency_earn`, `currency_spend`
- **Ad Events**: `ad_impression`
- **Performance Metrics**: `stats_fps`, `stats_critical_fps`

### **Query Highlights**
- Tracks A/B test groups (`abtest_group`) and test names (`abtest_name`) to enable detailed comparisons.
- Aggregates critical metrics like:
  - **User Metrics**: `unique_users`, `sessions_started`
  - **Engagement Metrics**: `round_started`, `round_completed`, `total_engagement_seconds`
  - **Monetization Metrics**: `cash_earn`, `trophy_spend`, `ad_imp_usd`
  - **Performance Metrics**: `avg_menu_fps`, `avg_game_fps`, `critical_fps_counts`
- Provides insights into user retention, performance optimization, and monetization strategies.

---

## **Setup**

### **1. BigQuery Integration**
- Copy the SQL query from `queries/ab_test_query.sql` into your BigQuery console.
- Update the dataset and table references to match your Firebase/GA4 dataset.

### **2. Looker Studio Configuration**
- Import the Looker Studio dashboard template from the `templates` folder.
- Connect it to your BigQuery data source for visualization.

---

## **Query Overview**

The main query processes the following key metrics:

| Metric                 | Description                                           |
|------------------------|-------------------------------------------------------|
| **unique_users**       | Number of unique users in the A/B test.              |
| **sessions_started**   | Number of sessions started.                          |
| **round_completed**    | Number of game rounds completed.                     |
| **cash_earn**          | Total cash earned during the test.                   |
| **ad_imp_usd**         | Total ad revenue (in USD) from impressions.          |
| **avg_menu_fps**       | Average FPS in the main menu.                        |
| **avg_game_fps**       | Average FPS during gameplay.                         |

Find the full query in the `queries` folder.

---

## **Example Use Cases**

1. **Compare A/B Test Results**:  
   Measure the impact of new features on user engagement, monetization, and retention.

2. **Region/Platform Analysis**:  
   Understand performance differences across geographic regions and platforms.

3. **Optimize Performance**:  
   Leverage FPS metrics to identify and resolve performance bottlenecks.

---

## **Future Improvements**

- Automate dashboard updates using scheduled BigQuery queries.
- Expand metrics to include retention (e.g., D1/D7) and LTV analysis.
- Integrate results with other BI tools for advanced reporting.

---

## **Contributing**

Contributions are welcome! If you have ideas for improvements or encounter issues, feel free to open a pull request or create an issue.

---

## **License**

This project is licensed under the MIT License. See the `LICENSE` file for details.
