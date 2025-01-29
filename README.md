# Website Optimization: Traffic Insights and A/B Testing

## Key Findings
- The alternative landing page `/lander-1` improved conversions by **27.7%** compared to `/home`, with a lower bounce rate and better user engagement across the funnel.
- The optimized billing page `/billing-2` achieved a **35.6% increase in conversion rates** and generated **$8,698.26 more in total revenue** than `/billing`.
  
---

## Overview
This project focuses on analyzing website performance and optimizing conversions through data-driven insights. It includes two sub-projects:

1. **Dynamic Website Traffic Analysis**:
   - Analyzes traffic sources and user behavior to identify key drivers of website performance.
   - Includes session trends, campaign contributions, and conversion rates.

2. **A/B Testing for Website Conversions**:
   - Evaluates the impact of landing page and billing page variations on user engagement and conversion rates.
   - Provides insights into improving the user journey and maximizing revenue.

## Project Context and Aim
The data used in this project reflects a use case where an analysis of an **e-commerce startup's new website** was conducted. After 8 months of operation, management wanted to evaluate progress and identify actionable insights to enhance performance. The goal is to understand user behavior, assess the effectiveness of marketing campaigns, and optimize website conversion rates to support business growth.

## Tools and Technologies
- **SQL**: Core analysis and data extraction.
- **Tableau**: Visualization of insights and trends.

---

## [Dynamic Website Traffic Analysis](https://github.com/Dolev-Yosef/Website-Optimization-Traffic-Insights-and-A-B-Testing/tree/main/Dynamic%20Website%20Traffic%20Analysis)

The **Dynamic Website Traffic Analysis** project aims to uncover actionable insights into user behavior, traffic sources, and conversion patterns to optimize website performance. Using Tableau for visualization, the analysis reveals key trends and highlights opportunities for improving traffic engagement and conversions.

### Key Insights

1. **Sessions by Source**:
   - **Google Paid Search campaigns** dominate traffic, accounting for the majority of sessions, followed by **Bing Paid Search** and **Non-campaign (Direct Traffic)**.
   - A significant spike in traffic is observed in **October and November**, indicating successful seasonal campaigns or promotional activities during these months.

2. **Sessions by Weekday and Hour**:
   - **Fridays and Mondays** see the highest website traffic with **38.4% of total sessions together**, with a significant drop in sessions over the weekend.
   - Peak traffic hours occur from **09:00 - 17:00**, suggesting this is when users are most active.

3. **Sessions by Campaign Type**:
   - **Nonbrand Google Paid Search campaigns** drive **74.70%** of total website sessions, emphasizing the importance of generic keywords in attracting users.
   - **Brand campaigns** account for a smaller proportion, indicating room for improvement in targeting branded keywords.
   - **Non-campaign traffic** shows a steady increase in session volume, reflecting growing brand awareness and intentional user searches for the company, which highlights its strengthening market presence.

4. **Device Performance Insights**:
   - Desktop devices dominate website sessions (**74.28%**) and exhibit significantly higher conversion rates, peaking at **5.33%** in October, compared to mobile devices, which contribute **25.72%** of sessions and peak at a modest **1.82%**, emphasizing the need to optimize desktop performance while addressing the challenges of improving mobile conversions.

5. **Conversion Rate: Sessions to Orders**:
   - Conversion rates steadily improve from **2.66% in March** to **4.53% in October**, reflecting successful optimization efforts or effective seasonal campaigns.
   - The upward trend highlights the potential for further growth by analyzing what worked during high-performing months.

---

### [Interactive Tableau Dashboard](https://public.tableau.com/views/WebsiteTrafficAnalysisDashboard_17380843709380/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

The Tableau dashboard serves as the visual representation of the insights derived from the analysis, allowing for dynamic filtering and data exploration. It provides a comprehensive view of traffic patterns and conversion performance, helping stakeholders make data-driven decisions.

- **Features**:
  - Dynamic filters for traffic source, campaign, and month.
  - Visualizations for sessions, conversion rates, and campaign contributions.
  - Granular insights into traffic by weekday and hour.

- **Access the Dashboard**:
  - You can view and interact with the dashboard [here on Tableau Public](https://public.tableau.com/views/WebsiteTrafficAnalysisDashboard_17380843709380/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).

---

## Summary
This analysis highlights the dominance of nonbrand campaigns in driving sessions, the importance of desktop optimizations for higher conversions, and the potential to grow branded campaigns and mobile performance. The insights empower data-driven decisions to improve website traffic and conversions.

---

## [A/B Testing for Website Conversions](https://github.com/Dolev-Yosef/Website-Optimization-Traffic-Insights-and-A-B-Testing/tree/main/AB%20Testing%20for%20Website%20Conversions)

The **A/B Testing for Website Conversions** project evaluates the performance of two key elements of the user journey: landing pages and billing pages. By analyzing user behavior and conversion rates across different test variations, this project identifies opportunities for optimization and provides actionable insights to improve the website's effectiveness.

### Part 1: Landing Page A/B Test

#### Overview
- **Objective**: Compare the performance of the default landing page (`/home`) with the alternative landing page (`/lander-1`) for the **gsearch nonbrand campaign**.
- **Test Period**: June 19, 2012 – July 28, 2012.
- **Traffic Split**: 50/50 between `/home` and `/lander-1`.

---

#### Key Metrics

1. **Bounce Rate**:
   - `/lander-1` has a lower bounce rate (**53.24%**) compared to `/home` (**58.34%**), indicating better user retention on the alternative landing page.

| Landing Page | Total Sessions | Bounced Sessions | Bounce Rate (%) |
|--------------|----------------|-------------------|-----------------|
| `/home`      | 2261           | 1319             | 58.34           |
| `/lander-1`  | 2316           | 1233             | 53.24           |

---

2. **Click-Through Rates (CTR) by Funnel Stage**:
   - `/lander-1` has a higher **landing-to-product CTR** (46.76%) compared to `/home` (41.66%), indicating that users landing on `/lander-1` are more likely to proceed to the product page.
   - For most intermediate stages (product, cart, and shipping), the performance differences between `/home` and `/lander-1` are minimal, suggesting comparable user progression.
   - **Billing-to-Thank-You CTR**: `/lander-1` (47.72%) significantly outperforms `/home` (42.86%), showing higher effectiveness at driving orders in the final stage.

| Landing Page | Landing to Product (%) | Product to Mr. Fuzzy (%) | Mr. Fuzzy to Cart (%) | Cart to Shipping (%) | Shipping to Billing (%) | Billing to Thank-You (%) |
|--------------|-------------------------|--------------------------|-----------------------|-----------------------|--------------------------|---------------------------|
| `/home`      | 41.66                  | 72.61                   | 43.27                | 67.57                | 84.00                   | 42.86                    |
| `/lander-1`  | 46.76                  | 71.28                   | 45.08                | 66.38                | 85.28                   | 47.72                    |

**Insight**: The improved engagement on `/lander-1` at critical stages (landing-to-product and billing-to-thank-you) highlights its effectiveness in converting users through the funnel.

---

3. **Conversion Rate: Sessions to Orders**:
   - `/lander-1` has a higher overall conversion rate (**4.06%**) compared to `/home` (**3.18%**), representing a **27.7% relative improvement** in conversion performance.
   - Total orders generated from `/lander-1` are **94**, compared to **72** from `/home`.

| Landing Page | Total Sessions | Total Orders | Conversion Rate (%) |
|--------------|----------------|--------------|----------------------|
| `/home`      | 2261           | 72           | 3.18                |
| `/lander-1`  | 2316           | 94           | 4.06                |

**Insight**: Despite a similar number of sessions, `/lander-1` consistently converts more users, making it the superior option for maximizing revenue.

---

### Summary of Insights

1. **Bounce Rate**:
   - `/lander-1` shows better user retention with a **5% lower bounce rate**, indicating a more engaging design or content.

2. **Funnel Performance**:
   - Users landing on `/lander-1` are more likely to progress through the conversion funnel, particularly in the initial stage (landing-to-product) and the final stage (billing-to-thank-you).

3. **Conversion Rate**:
   - `/lander-1` outperforms `/home` with a **higher conversion rate** and **greater total orders**, making it the recommended landing page for similar campaigns.

4. **Effectiveness of /lander-1**:
   - The 0.88% higher conversion rate translates to a **27.7% improvement**, highlighting the significant impact of the alternative landing page on driving revenue.

---

### Part 2: Billing Page A/B Test

#### Overview
- **Objective**: Compare the performance of two billing page designs (`/billing` and `/billing-2`) to determine which is more effective at driving conversions and generating revenue.
- **Test Period**: September 10, 2012 – November 30, 2012.

---

#### Key Metrics

1. **Conversion Rate**:
   - `/billing-2` achieves a **higher conversion rate** of **61.09%**, outperforming `/billing` at **45.04%**.

2. **Revenue**:
   - Total revenue generated by `/billing-2` is **$34,143.17**, significantly higher than `/billing`'s **$25,444.91**.

3. **Revenue Per Billing Page Session**:
   - `/billing-2` achieves a **revenue per session** of **$30.54**, compared to `/billing` at **$22.52**, representing a substantial improvement in monetization.

| Billing Segment | Page Views | Orders | Conversion Rate (%) | Revenue ($) | Revenue per Billing Page Session ($) |
|-----------------|------------|--------|----------------------|-------------|---------------------------------------|
| `/billing`      | 1130       | 509    | 45.04               | 25,444.91   | 22.52                                 |
| `/billing-2`    | 1118       | 683    | 61.09               | 34,143.17   | 30.54                                 |

---

#### Insights

1. **Conversion Rate**:
   - `/billing-2` significantly outperforms `/billing` in terms of conversion rate, with an improvement of **16.05%** (35.6% relative increase), indicating a more effective checkout experience.

2. **Revenue Impact**:
   - With **$8,698.26** more in total revenue and a **$8.02** higher revenue per session, `/billing-2` demonstrates its superior ability to maximize revenue.

3. **Overall Performance**:
   - The higher performance metrics for `/billing-2` (conversion rate, total revenue, and revenue per session) suggest that its design or layout addresses user needs more effectively, making it the preferred choice for the billing page.

---

### Next Steps
1. **Adopt `/lander-1` and `/billing-2` as default pages** to maximize conversions and revenue.
2. **Analyze key elements of success** (e.g., layout, content, CTAs) to identify what drives user engagement.
3. **Expand A/B testing** to optimize further and address performance gaps, such as mobile conversions and branded campaigns.



