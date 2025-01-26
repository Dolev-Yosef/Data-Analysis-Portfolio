USE mavenfuzzyfactory;

-- PART 1: Analyzing Landing Page A/B Test
-- The analysis focuses on the A/B test conducted between 2012-06-19 and 2012-07-28
-- for the gsearch nonbrand campaign. The test compares the default landing page (/home)
-- and the alternative landing page (/lander-1) with a 50/50 traffic split.

-- Calculating Bounce Rate:
-- The goal is to identify sessions with the first pageview (landing page) for the specified test period.

CREATE TEMPORARY TABLE session_with_landing_page
SELECT 
	session_landing_page_id.website_session_id,
    wp.pageview_url AS landing_page
FROM (
			-- Subquery: Retrieves relevant sessions with the first pageview (landing page ID)
		SELECT 
			wp.website_session_id,
			MIN(wp.website_pageview_id) AS min_pageview_id
		FROM
			website_pageviews wp
				JOIN
			website_sessions ws ON wp.website_session_id = ws.website_session_id
		WHERE
			ws.created_at >= '2012-06-19'
				AND ws.created_at <= '2012-07-28'
				AND utm_source = 'gsearch'
				AND utm_campaign = 'nonbrand'
		GROUP BY website_session_id) AS session_landing_page_id
    LEFT JOIN
    website_pageviews wp ON  session_landing_page_id.min_pageview_id = wp.website_pageview_id;
;

-- select * from session_with_landing_page; -- for QA



-- Temporary table for bounced sessions (single pageview)
create temporary table bounced_sessions_test
SELECT 
    sl.website_session_id, COUNT(DISTINCT website_pageview_id)
FROM
    session_with_landing_page sl
        JOIN
    website_pageviews wp ON sl.website_session_id = wp.website_session_id
GROUP BY sl.website_session_id
HAVING COUNT(DISTINCT website_pageview_id) = 1; -- sessions with one page view, means that the user bounced off the website.



-- Calculate bounce rate by landing page
SELECT 
    sl.landing_page AS landing_page,
    COUNT(DISTINCT sl.website_session_id) AS total_sessions,
    COUNT(DISTINCT bs.website_session_id) AS bounced_sessions,
	ROUND(COUNT(DISTINCT bs.website_session_id) / COUNT(DISTINCT sl.website_session_id) * 100, 2) AS bounce_rate
FROM
    session_with_landing_page sl
        LEFT JOIN
    bounced_sessions_test bs ON sl.website_session_id = bs.website_session_id
GROUP BY sl.landing_page;



-- Insights:
/*Bounce Rate Comparison:

/lander-1 has a lower bounce rate (53.24%) compared to /home (58.34%), suggesting that /lander-1 performs slightly better at retaining users.
While the difference in bounce rate (around 5 percentage points) might seem small, it could be significant depending on the business's goals (e.g., reducing user drop-off).

Traffic Distribution:
The test seems to have a balanced 50/50 split between /home and /lander-1, with a slight variance in session count (2261 vs. 2316).
This is a good validation that the A/B test setup worked as intended.

User Behavior on Landing Pages:
/lander-1 appears to engage users better, as a smaller proportion of its visitors bounced compared to /home.
*/



-- Landing Page A/B test for gsearch nonbrand campaign, btween the 2012-06-19 and 2012-07-28
-- Perform a funnel analysis to segment sessions based on landing pages (/home or /lander-1) and track user progression through key pages in the conversion funnel. 

create temporary table session_page_flags
SELECT 
        sessions_pageviews.website_session_id,
		MAX(sessions_pageviews.to_home) AS to_home,  -- For every session, flag the visited pages
		MAX(sessions_pageviews.to_lander) AS to_lander,
		MAX(sessions_pageviews.to_products) AS to_products,
		MAX(sessions_pageviews.to_mr_fuzzy) AS to_mr_fuzzy,
		MAX(sessions_pageviews.to_cart) AS to_cart,
		MAX(sessions_pageviews.to_shipping) AS to_shipping,
		MAX(sessions_pageviews.to_billing) AS to_billing,
		MAX(sessions_pageviews.to_thank_you) AS to_thankyou
FROM
	(SELECT                        -- Subquery: Retrieves relevant sessions and flags page visits for the gsearch nonbrand campaign
		ws.website_session_id,
		wp.pageview_url,
		CASE WHEN wp.pageview_url = '/home' THEN 1 ELSE 0 END AS to_home,  -- Flag every visit to a page on the website
		CASE WHEN wp.pageview_url = '/lander-1' THEN 1 ELSE 0 END AS to_lander,
		CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END AS to_products,
		CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS to_mr_fuzzy,
		CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END AS to_cart,
		CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END AS to_shipping,
		CASE WHEN wp.pageview_url = '/billing' THEN 1 ELSE 0 END AS to_billing,
		CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS to_thank_you
	FROM
		website_sessions ws
			LEFT JOIN
		website_pageviews wp ON ws.website_session_id = wp.website_session_id
	WHERE
		ws.utm_source = 'gsearch'
			AND ws.utm_campaign = 'nonbrand'
			AND ws.created_at > '2012-06-19'
			AND ws.created_at < '2012-07-28') as sessions_pageviews
GROUP BY  sessions_pageviews.website_session_id
	;
 -- select * from session_page_flags; -- for QA


-- Segment sessions based on the landing page (/home or /lander-1) and count the number of visits to each page in the funnel for each segment.
create temporary table funnels_for_landing_page_test  
SELECT 
    CASE                                   
        WHEN s.to_home = 1 THEN '/home'
        WHEN s.to_lander = 1 THEN '/lander-1'
        ELSE NULL
    END AS landing_page,
    count(distinct s.website_session_id) as sessions,     
    sum(s.to_products) as to_product,
    sum(s.to_mr_fuzzy) as to_mr_fuzzy,
    sum(s.to_cart) as to_cart,
    sum(s.to_shipping) as to_shipping,
	sum(s.to_billing) as to_billing,
    sum(s.to_thankyou) as to_thankyou
FROM
	session_page_flags s   
group by landing_page
;
-- select * from funnels_for_landing_page_test; -- for QA


-- FULL Click-Through Rate (CTR) funnel for all website pages, analyzing landing page A/B testing.
select 
	f.landing_page,
    round((f.to_product / f.sessions) * 100, 2) as landing_to_product_CTR,
    round((f.to_mr_fuzzy / f.to_product) * 100, 2) as product_to_mr_fuzzy_CTR,
    round((f.to_cart / f.to_mr_fuzzy) * 100, 2) as mr_fuzzy_to_cart_CTR,
    round((f.to_shipping / f.to_cart) * 100, 2) as cart_to_shipping_CTR,
	round((f.to_billing / f.to_shipping) * 100, 2) as shipping_to_billing_CTR,
    round((f.to_thankyou / f.to_billing) * 100, 2) as billing_to_thankyou_CTR
from funnels_for_landing_page_test f;



-- Insights from the Funnel Analysis:
/*
Landing Page CTR:
/lander-1 has a higher landing page CTR (46.76%) compared to /home (41.66%). This indicates that users landing on /lander-1 are more likely to proceed to the next stage (product page).
Insight: The design or content on /lander-1 might be more effective at engaging users and encouraging further exploration.

In the product, Mr. Fuzzy, cart, and shipping pages, the differences in performance between the funnels are minimal, suggesting both landing pages have a comparable impact on user progression through these stages.

Billing Page CTR:
/lander-1 has a higher billing page CTR (47.72%) compared to /home (42.86%), indicating that users from /lander-1 are more likely to create an order at the billing stage.
Insight: This suggests that /lander-1 may attract more high-intent users who are ready to complete their purchases, making it more effective at driving conversions at the critical final stage of the funnel.
*/



-- Conversion Rate from sessions to orders for landing page A/B testing
select 
	f.landing_page,
    f.sessions AS total_sessions,
    f.to_thankyou AS total_orders,
    round((f.to_thankyou / f.sessions) * 100, 2) as conversion_sessions_to_orders
from funnels_for_landing_page_test f;


-- insights: 
/*Insights from the Conversion Rate Analysis
Conversion Rate Comparison:

/lander-1 outperforms /home in conversion rate:
/lander-1: 4.06%
/home: 3.18%
Insight: This indicates that sessions starting on /lander-1 are more likely to result in orders compared to /home.
Total Orders:

/lander-1 generated 94 orders, while /home generated 72 orders, despite both landing pages having similar session counts.
Insight: The higher number of total orders for /lander-1 further highlights its effectiveness in converting visitors into customers.
Effectiveness of /lander-1:

The 0.88 percentage point difference in conversion rate may seem small, but it represents a 27.7% improvement in relative terms.
Insight: This makes /lander-1 a significantly better choice for driving conversions.
*/




-- PART 2 - A/B test for Billing Page
-- Analyze the A/B test for billing pages (`/billing` and `/billing-2`) that ran from 2012-09-10 to 2012-11-30.
-- This query calculates:
-- 1. Conversion rate from billing page sessions to orders.
-- 2. Total revenue generated per billing page segment.
-- 3. Revenue per billing page session.

SELECT 
    wp.pageview_url AS billing_segment,
    COUNT(DISTINCT wp.website_session_id) AS page_views,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND((COUNT(DISTINCT o.order_id) / COUNT(DISTINCT wp.website_session_id) * 100), 2) AS conversion_rate,
    SUM(o.price_usd) AS revenue,
    ROUND(SUM(o.price_usd) / COUNT(DISTINCT wp.website_session_id),
            2) AS revenue_per_billing_page_session
FROM
    website_pageviews wp
        LEFT JOIN
    orders o ON wp.website_session_id = o.website_session_id
WHERE
    wp.created_at >= '2012-09-10'
        AND wp.created_at < '2012-11-30'
        AND wp.pageview_url IN ('/billing' , '/billing-2')
GROUP BY billing_segment
;
















