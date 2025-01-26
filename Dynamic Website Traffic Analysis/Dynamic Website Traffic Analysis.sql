USE mavenfuzzyfactory;


-- Analyzing Traffic Sources
-- This section focuses on analyzing traffic sources to understand user behavior and conversion rates.


-- overall analysis of session to order conversion rates by month.
SELECT 
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
	round((COUNT(o.order_id) / COUNT(ws.website_session_id)) * 100, 2)  AS sessions_to_orders_conversion_rate
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON ws.website_session_id = o.website_session_id
WHERE
    ws.created_at < '2012-11-30'
GROUP BY YEAR(ws.created_at) , MONTH(ws.created_at)
ORDER BY year , month
;




-- Diving deeper into a specific traffic source: gsearch
-- This query analyzes monthly trends for sessions and orders originating from the 'gsearch' traffic source. 
-- 'gsearch' represents sessions originating from Google search ads
-- It calculates the conversion rate from sessions to orders.


SELECT 
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders,
    round(COUNT(o.order_id) / COUNT(ws.website_session_id) * 100 , 2) as convertion_rate
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON ws.website_session_id = o.website_session_id
WHERE
    ws.created_at < '2012-11-30'
        AND ws.utm_source = 'gsearch'
GROUP BY YEAR(ws.created_at) , MONTH(ws.created_at)
ORDER BY year , month
;




-- Monthly trend analysis for gsearch sessions and orders, splitting out nonbrand and brand campaigns, including conversion rates.
-- * Brand campaigns represent someone explicitly searching for the company in the search engine.

SELECT 
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END) AS nonbrand_sessions,
    COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS nonbrand_orders,
    COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN ws.website_session_id ELSE NULL END) AS brand_sessions,
    COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS brand_orders,
    
    -- Calculate nonbrand conversion rate (nonbrand_orders / nonbrand_sessions)
    ROUND((COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END)) * 100, 2) AS nonbrand_con_rate,
    
    -- Calculate brand conversion rate (brand_orders / brand_sessions)
	ROUND(COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN o.order_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN ws.website_session_id ELSE NULL END) * 100, 2) AS brand_con_rate -- brand_orders/brand_sessions
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON ws.website_session_id = o.website_session_id
WHERE
    ws.created_at < '2012-11-30'
        AND ws.utm_source = 'gsearch'
GROUP BY YEAR(ws.created_at) , MONTH(ws.created_at)
ORDER BY year , month
;



-- Focusing on gsearch nonbrand campaign
-- Analyzing monthly sessions, orders, and conversion rates by device type (desktop vs. mobile)

SELECT 
    YEAR(ws.created_at) as year,
    MONTH(ws.created_at) as month,
	COUNT(DISTINCT CASE WHEN ws.device_type = 'desktop' THEN ws.website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(DISTINCT CASE WHEN ws.device_type = 'mobile' THEN ws.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN ws.device_type = 'desktop' THEN o.order_id ELSE NULL END) AS desktop_orders,
    COUNT(DISTINCT CASE WHEN ws.device_type = 'mobile' THEN o.order_id ELSE NULL END) AS mobile_orders,
    
   round(COUNT(DISTINCT CASE WHEN ws.device_type = 'desktop' THEN o.order_id ELSE NULL END)/ COUNT(DISTINCT CASE WHEN ws.device_type = 'desktop' THEN ws.website_session_id ELSE NULL END) * 100, 2) as conv_rate_desktop,  --  desktop_orders / desktop_sessions 
   round( COUNT(DISTINCT CASE WHEN ws.device_type = 'mobile' THEN o.order_id ELSE NULL END)/ COUNT(DISTINCT CASE WHEN ws.device_type = 'mobile' THEN ws.website_session_id ELSE NULL END) * 100, 2) as conv_rate_desktop --  desktop_orders / desktop_sessions 
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON ws.website_session_id = o.website_session_id
WHERE
    ws.created_at < '2012-11-30'
        AND ws.utm_source = 'gsearch'
        AND ws.utm_campaign = 'nonbrand'
GROUP BY YEAR(ws.created_at) , MONTH(ws.created_at)
ORDER BY year , month
;



-- Monthly trend of traffic sources
-- Understanding from where traffic arrives at the website.

-- Logic:
-- 1. If `utm_source` = 'gsearch', it's Google paid search traffic.
-- 2. If `utm_source` = 'bsearch', it's Bing paid search traffic.
-- 3. If `utm_source` is NULL and `http_referer` is NOT NULL, it's organic search traffic.
-- 4. If `utm_source`, `utm_campaign`, and `http_referer` are NULL, it's direct (typed-in) traffic.

SELECT 
    YEAR(ws.created_at) as year,
    MONTH(ws.created_at) as month,
	COUNT(CASE WHEN ws.utm_source = 'gsearch' THEN ws.website_session_id ELSE NULL END) AS gsearch_paid_sessions,  -- Count sessions from Google paid search (utm_source = 'gsearch')
    COUNT(CASE WHEN ws.utm_source = 'bsearch' THEN ws.website_session_id ELSE NULL END) AS bsearch_paid_sessions,  -- Count sessions from Bing paid search (utm_source = 'bsearch')
    COUNT(CASE WHEN ws.utm_source IS NULL AND ws.http_referer IS NOT NULL THEN ws.website_session_id ELSE NULL END) AS organic_search_sessions, -- Count sessions from organic search
    COUNT(CASE WHEN ws.utm_source IS NULL AND ws.http_referer IS NULL THEN ws.website_session_id ELSE NULL END) AS direct_sessions -- Count direct sessions
FROM
    website_sessions ws
WHERE
    ws.created_at < '2012-11-30'
GROUP BY YEAR(ws.created_at) , MONTH(ws.created_at)
;




