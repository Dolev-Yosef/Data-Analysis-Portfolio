USE mavenfuzzyfactory;




-- section 1: Analyzing Traffic Sources




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





-- diving deeper into a spacific traffic source 
-- Monthly trend analysis for gsearch sessions and orders, calculation convertion rate from sessions to orders.

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




-- Monthly trend analysis for gsearch sessions and orders, splitting out nonbrand and brand campaigns, includes convertion rates.
-- * brand campaigns represnt someone in search engine expelcictly looking for the company/

SELECT 
    YEAR(ws.created_at) AS year,
    MONTH(ws.created_at) AS month,
    COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END) AS nonbrand_sessions,
    COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) AS nonbrand_orders,
    COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN ws.website_session_id ELSE NULL END) AS brand_sessions,
    COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'brand' THEN o.order_id ELSE NULL END) AS brand_orders,
   
    ROUND((COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'nonbrand' THEN o.order_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN ws.utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE NULL END)) * 100, 2) AS nonbrand_con_rate, -- nonbrand_orders / nonbrand_sessions
    
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





-- focucing on gsearch nonbrand campaign, monthly sessions and orders by device type and convertion rate. 

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




-- Monthly trend of traffic sources, undrstanding from where traffic arrives to the website.
-- utm_sources, utm_campaign, http_referer , when all there are null then its direct type in traffic. If utm_source and utm_campaign are null, and there is a http referer, organig search traffic.

SELECT 
    YEAR(ws.created_at) as year,
    MONTH(ws.created_at) as month,
	COUNT(CASE WHEN ws.utm_source = 'gsearch' THEN ws.website_session_id ELSE NULL END) AS gsearch_paid_sessions,
    COUNT(CASE WHEN ws.utm_source = 'bsearch' THEN ws.website_session_id ELSE NULL END) AS bsearch_paid_sessions,
    COUNT(CASE WHEN ws.utm_source IS NULL AND ws.http_referer IS NOT NULL THEN ws.website_session_id ELSE NULL END) AS organic_search_sessions,
    COUNT(CASE WHEN ws.utm_source IS NULL AND ws.http_referer IS NULL THEN ws.website_session_id ELSE NULL END) AS direct_sessions
FROM
    website_sessions ws
WHERE
    ws.created_at < '2012-11-30'
GROUP BY YEAR(ws.created_at) , MONTH(ws.created_at)
;








--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- section 2: Analyzing Website Performance



-- PART 1 

-- Analyzing Landing Page A/B test. 
-- Landing Page A/B test for gsearch nonbrand campaign, btween the 2012-06-19 and 2012-07-28
-- The website manager craeted a 50/50 split test on landing page /home and the alternative landing page /lander-1 for traffic coming from the gsearch nonbrand campaign.



-- calculating Bounce Rate.
-- ALL sessions with the landing page url. 
CREATE TEMPORARY TABLE session_with_landing_page
SELECT 
	session_landing_page_id.website_session_id,
    wp.pageview_url AS landing_page

FROM (
			-- subquery: retrives relevent sessions with the landing page id
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



-- website sesstions that were "bounced sessions" 
create temporary table bounced_sessions_test
SELECT 
    sl.website_session_id, COUNT(DISTINCT website_pageview_id)
FROM
    session_with_landing_page sl
        JOIN
    website_pageviews wp ON sl.website_session_id = wp.website_session_id
GROUP BY sl.website_session_id
HAVING COUNT(DISTINCT website_pageview_id) = 1; -- sessions with one page view, means that the user bounced off the website.



-- table of landing page and the bounce rate metric
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



-- insights: the original "home" landing page with 58.34% bounce rate, as the alternative "lander-1" landing page has a bounce rate of 53.24%. 
-- this meant that lander-1 is proforming better. 






-- Landing Page A/B test for gsearch nonbrand campaign, btween the 2012-06-19 and 2012-07-28
-- Funnel analysis


create temporary table session_page_flags
SELECT 
        sessions_pageviews.website_session_id,
		MAX(sessions_pageviews.to_home) AS to_home,  -- for every session, flag the visited pages
		MAX(sessions_pageviews.to_lander) AS to_lander,
		MAX(sessions_pageviews.to_products) AS to_products,
		MAX(sessions_pageviews.to_mr_fuzzy) AS to_mr_fuzzy,
		MAX(sessions_pageviews.to_cart) AS to_cart,
		MAX(sessions_pageviews.to_shipping) AS to_shipping,
		MAX(sessions_pageviews.to_billing) AS to_billing,
		MAX(sessions_pageviews.to_thank_you) AS to_thankyou
FROM
	(SELECT                        -- subquery to retrive the gsearch nonbrand campaign, in the dates when the test was live
		ws.website_session_id,
		wp.pageview_url,
		CASE WHEN wp.pageview_url = '/home' THEN 1 ELSE 0 END AS to_home,  -- flag every visit to a page on the website
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




-- seprate the sessions to two segments by landing page
-- count the number of page visits in each segment
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




-- FULL Click Through Rate funnel of all website pages, for landing page A/B testing.
select 
	f.landing_page,
    concat(round((f.to_product / f.sessions) * 100, 2), '%') as landing_page_CTR,
    concat(round((f.to_mr_fuzzy / f.to_product) * 100, 2), '%') as product_page_CTR,
    concat(round((f.to_cart / f.to_mr_fuzzy) * 100, 2), '%') as mr_fuzzy_page_CTR,
    concat(round((f.to_shipping / f.to_cart) * 100, 2), '%') as cart_page_CTR,
	concat(round((f.to_billing / f.to_shipping) * 100, 2), '%') as shipping_page_CTR,
    concat(round((f.to_thankyou / f.to_billing) * 100, 2), '%') as billing_page_CTR
from funnels_for_landing_page_test f;

-- insights: for the funnel analysis, we can see that "lander-1" has a higher Click Through Rate, with 46.76%, than "home" with 41.66%. This showes that the useres are more intrested to proced to product page when using lander-1.
-- useres that started the website session in the lander-1 landing page, had a higher billing page CTR with 47.72% , than the "home" landing page with 42.86%


-- Convertion Rate from sesstion to orders, for landing page A/B testing
select 
	f.landing_page,
    concat(round((f.to_thankyou / f.sessions) * 100, 2), '%') as convertion_sessions_to_orders
from funnels_for_landing_page_test f;


-- insights: cnvartion rate from sessions to orders: lander-1 4.06 %, home - 3.18%







-- PART 2 - A/B test for billing page. The test was live from 2012-09-10 until 2012-11-30

-- A/B testing billing page, calculating convertion rate from billing page to orders. 

-- calculating revenue per billing page session
SELECT 
    wp.pageview_url AS billing_segment,
    COUNT(DISTINCT wp.website_session_id) AS page_views,
    COUNT(DISTINCT o.order_id) AS orders,
    concat(round((COUNT(DISTINCT o.order_id) / COUNT(DISTINCT wp.website_session_id) * 100), 2), '%') as convertion_rate_billing_to_orders,
    sum(o.price_usd) as revenue,
    round(sum(o.price_usd) / COUNT(DISTINCT wp.website_session_id), 2) as revenue_per_billing_page_session

FROM
	website_pageviews wp
    LEFT JOIN orders o ON wp.website_session_id = o.website_session_id
WHERE
        wp.created_at >= '2012-09-10'
            AND wp.created_at < '2012-11-30'
            AND wp.pageview_url IN ('/billing' , '/billing-2')
GROUP BY billing_segment
;
















