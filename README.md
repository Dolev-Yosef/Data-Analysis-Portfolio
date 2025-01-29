# Website Optimization: Traffic Insights and A/B Testing

## Overview
This project focuses on analyzing website performance and optimizing conversions through data-driven insights. It includes two sub-projects:

1. **Dynamic Website Traffic Analysis**:
   - Analyzes traffic sources and user behavior to identify key drivers of website performance.
   - Includes session trends, campaign contributions, and conversion rates.

2. **A/B Testing for Website Conversions**:
   - Evaluates the impact of landing page and billing page variations on user engagement and conversion rates.
   - Provides insights into improving the user journey and maximizing revenue.


## Tools and Technologies
- **SQL**: Core analysis and data extraction.
- **Tableau**: Visualization of insights and trends.

[## Dynamic Website Traffic Analysis](Dynamic Website Traffic Analysis/Dynamic Website Traffic Analysis.sql) 

The **Dynamic Website Traffic Analysis** project aims to uncover actionable insights into user behavior, traffic sources, and conversion patterns to optimize website performance. Using Tableau for visualization, the analysis reveals key trends and highlights opportunities for improving traffic engagement and conversions.

### Key Insights from the Dashboard

1. **Sessions by Source**:
   - **Google Paid Search campaigns** dominate traffic, accounting for the majority of sessions, followed by **Bing Paid Search** and **Non-campaign (Direct Traffic)**.
   - A significant spike in traffic is observed in **October and November**, indicating successful seasonal campaigns or promotional activities during these months.

2. **Sessions by Weekday and Hour**:
   - **Fridays and Mondays** see the highest website traffic with 38.4% of total sessions together, with a significant drop in sessions over the weekend.
   - Peak traffic hours occur from **09:00 - 17:00**, suggesting this is when users are most active.

3. **Sessions by Campaign Type**:  
   - **Nonbrand Google Paid Search campaigns** drive 74.70% of total website sessions, emphasizing the importance of generic keywords in attracting users.  
   - **Brand campaigns** account for a smaller proportion, indicating room for improvement in targeting branded keywords.  
   - **Non-campaign traffic** shows a steady increase in session volume, reflecting growing brand awareness and intentional user searches for the company, which highlights its strengthening market presence.


4. **Device Performance Insights**:
   - Desktop devices dominate website sessions (74.28%) and exhibit significantly higher conversion rates, peaking at **5.33%** in October, compared to mobile devices, which contribute 25.72% of sessions and peak at a modest **1.82%**, emphasizing the need to optimize desktop performance while addressing the challenges of improving mobile conversions.

5. **Conversion Rate: Sessions to Orders**:
   - Conversion rates steadily improve from **2.66% in March** to **4.53% in October**, reflecting successful optimization efforts or effective seasonal campaigns.
   - The upward trend highlights the potential for further growth by analyzing what worked during high-performing months.

### Interactive Tableau Dashboard

The Tableau dashboard visualizes these insights dynamically, offering the ability to filter by traffic source, campaign type, and month. It provides a comprehensive view of traffic patterns and conversion performance, helping stakeholders make data-driven decisions.

- **Features**:
  - Dynamic filters for traffic source, campaign, and month.
  - Visualizations for sessions, conversion rates, and campaign contributions.
  - Granular insights into traffic by weekday and hour.

- **Access the Dashboard**:
  - You can view and interact with the dashboard [here on Tableau Public](https://public.tableau.com/views/WebsiteTrafficAnalysisDashboard_17380843709380/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).

### How to Use
1. **Run the Queries**:
   - Use the SQL queries provided in the `queries/` directory to extract data from the Maven Fuzzy Factory database.

2. **Explore the Dashboard**:
   - Visualize insights dynamically with the Tableau dashboard.

3. **Analyze Key Metrics**:
   - Use the dashboard to understand user behavior, evaluate campaign performance, and identify areas for optimization.
