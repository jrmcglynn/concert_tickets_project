-- SCRIPT TO CREATE INDICATOR TABLE
CREATE OR REPLACE VIEW sandbox.response_var AS

--Indicator
WITH ind AS
(SELECT
  listing_id,
  ticket_splits_option,
  date_accessed,
  TO_DATE(date_accessed, 'YYYY_MM_DD') AS date,
  LEAD(0) OVER (PARTITION BY
                  listing_id, ticket_splits_option
                 ORDER BY
                  TO_DATE(date_accessed, 'YYYY_MM_DD') ASC)
        AS indicator
FROM
  stubhub.tickets_splits
ORDER BY
  1, 2, 3)

SELECT
  ind.listing_id,
  ind.ticket_splits_option,
  ind.date_accessed,
  ind.date,
  NVL(ind.indicator, 1) AS indicator
FROM
  ind
JOIN --Filter out records where we did not get tickets for that event the next day
      --...or, it is a GA Ticket
  stubhub.tickets_df t
  ON
    t.listing_id = ind.listing_id
    AND TO_DATE(t.date_accessed, 'YYYY_MM_DD') = ind.date
    AND NOT t.is_ga
    AND t.section_name NOT IN ('General Admission', 'General Admission Floor',
                             'Floor General Admission', 'General Admission Standing 2',
                             'General Admission Balcony',
                              'GA', 'PARKING PASS')
    AND t.zone_name NOT IN ('General Admission', 'Floor General Admission', 'GA', 'General Admission Floor',
                             'Main Floor General Admission', 'General Admission Balcony', 'Pit GA', 'GA Floor', 'GA Balcony',
                             'Mezzanine GA', 'Balcony GA')
JOIN
  stubhub.events_ticket_summary e
  ON
    e.event_id = t.event_id
    AND TO_DATE(e.date_accessed, 'YYYY_MM_DD') = ind.date + 1
    
WITH NO SCHEMA BINDING
;

--CHECK THE AVERAGE AVAILABILITY BY DAY
SELECT
 date_accessed,
 AVG(1.0000*indicator)
FROM
  sandbox.response_var
 GROUP BY 1
LIMIT 100

;
SELECT
  r.*,
  e.event_listing_n
FROM
  sandbox.response_var r
JOIN
  stubhub.tickets_df t
  ON
    t.date_accessed = r.date_accessed
    AND t.listing_id = r.listing_id
JOIN
  (SELECT
    t.event_id,
    COUNT(DISTINCT t.listing_id) AS event_listing_n
  FROM
    stubhub.tickets_df t
  GROUP BY
    1) e
  ON
    e.event_id = t.event_id
LIMIT 100
;

--CREATE A VIEW WITH THE DATE FEAURES
CREATE OR REPLACE VIEW sandbox.features_date AS
SELECT
  e.event_id,
  t.date_accessed,
  TO_DATE(e.eventdatelocal, 'YYYY-MM-DD') - TO_DATE(t.date_accessed, 'YYYY-MM-DD') AS days_until_show,
  DATE_PART(dow, TO_DATE(t.date_accessed, 'YYYY-MM-DD')) AS dow_listing_avail,
  DATE_PART(dow, TO_DATE(e.eventdatelocal, 'YYYY-MM-DD')) AS dow_show
FROM
  stubhub.events_df e
JOIN
  stubhub.tickets_df t
  ON e.event_id = t.event_id
GROUP BY
  1, 2, 3, 4, 5
ORDER BY
  1, 2, 3
;

SELECT
  r.listing_id,
  r.ticket_splits_option,
  r.date,
  r.indicator,
  d.*
FROM
  sandbox.response_var r
JOIN
  stubhub.tickets_df t
  ON
    t.listing_id = r.listing_id
    AND t.date_accessed = r.date_accessed
JOIN
  sandbox.features_date d
  ON d.event_id = t.event_id
    AND d.date_accessed = r.date_accessed
LIMIT 100
;
SELECT
  t.is_ga,
  t.section_name,
  t.zone_name,
  COUNT(*)
FROM
  stubhub.tickets_df t
WHERE
  NOT t.is_ga
GROUP BY
  1, 2, 3
ORDER BY
  4 DESC
LIMIT
  1000
  

;
SELECT
  t.*,
  TO_DATE(t.eventdatelocal, 'YYYY-MM-DD') as d
FROM
  stubhub.events_df t
ORDER BY
  d DESC
LIMIT 100;
SELECT
  e.event_id,
  e.geos,
  d.days_until_show,
  AVG(r.indicator) AS mean_availability
FROM
  sandbox.response_var r
JOIN
  stubhub.tickets_df t
  ON
    t.date_accessed = r.date_accessed
    AND t.listing_id = r.listing_id
JOIN
  (SELECT
    t.event_id,
    COUNT(DISTINCT t.listing_id) AS event_listing_n
  FROM
    stubhub.tickets_df t
  GROUP BY
    1) e
  ON
    e.event_id = t.event_id
JOIN
    stubhub.events_df ev
    ON ev.event_id = t.event_id
JOIN
  sandbox.features_date d
  ON d.event_id = t.event_id
    AND d.date_accessed = r.date_accessed
GROUP BY
    1, 2, 3
;
SELECT * FROM stubhub.events_ticket_summary LIMIT 100;
SELECT COUNT(*) FROM sandbox.response_var
;
SELECT
  t.listing_id,
  t.date_accessed,
  COUNT(*)
FROM
  stubhub.tickets_df t
GROUP BY
  1, 2
ORDER by 3 desc
;
SELECT
  COUNT(r.*),
  COUNT(t.*)
FROM
  sandbox.response_var r
JOIN
  stubhub.tickets_df t
  ON
    t.listing_id = r.listing_id
    and t.date_accessed = r.date_accessed
;

select * from sandbox.response_var limit 10;
SELECT * FROM
(SELECT
  p.performer_id,
  p.event_id,
  COUNT(performer_id) OVER (PARTITION BY performer_id) AS total_events
FROM
  stubhub.events_perf p)
WHERE total_events > 10;

select COUNT(*) from stubhub.events_df ;
SELECT COUNT(DISTINCT event_id) FROM stubhub.events_perf;

SELECT
  t.zone_name,
  COUNT(*) AS n_listings
FROM
  stubhub.tickets_df t
GROUP BY
  1
ORDER BY 2 DESC
LIMIT 100
;
select r.date, count(*)

from sandbox.response_var r
group by 1
;
select
COUNT(DISTINCT event_id)
from
stubhub.events_df;


SELECT
  t.event_id,
  COUNT(DISTINCT t.listing_id) AS unique_listings,
  COUNT(s.*) AS obvs
FROM
  stubhub.tickets_splits s
JOIN
  stubhub.tickets_df t
  ON
    t.listing_id = s.listing_id
    AND t.date_accessed = s.date_accessed
GROUP BY
  1;
SELECT COUNT(DISTINCT performer_id)
FROM stubhub.events_perf
;
SELECT COUNT(DISTINCT venue_id)
FROM stubhub.events_df
