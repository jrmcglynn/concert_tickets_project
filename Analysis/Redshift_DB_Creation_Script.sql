--CREATE WORKING SCHEMA TO STAGE INSERTS
CREATE SCHEMA IF NOT EXISTS working
;
--CREATE STUBHUB SCHEMA
CREATE SCHEMA IF NOT EXISTS stubhub
;
--CREATE SANDBOX SCHEMA FOR CUSTOM TABLES (E.g., model features)
CREATE SCHEMA IF NOT EXISTS sandbox
;

--TICKETS SPLITS
CREATE TABLE stubhub.tickets_splits(
  listing_id INTEGER,
  ticket_splits_option FLOAT(1),
  date_accessed CHAR (10),
  dt_accessed TIMESTAMP);

COPY stubhub.tickets_splits FROM 's3://nycdsa.ta-am/tickets_splits_2018_09_11.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;

CREATE TABLE working.temp_tickets_splits(LIKE stubhub.tickets_splits);
  
COPY working.temp_tickets_splits FROM 's3://nycdsa.ta-am/tickets_splits_2018_09_08.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;
  
COPY working.temp_tickets_splits FROM 's3://nycdsa.ta-am/tickets_splits_2018_09_09.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;
  
COPY working.temp_tickets_splits FROM 's3://nycdsa.ta-am/tickets_splits_2018_09_10.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;
  
COPY working.temp_tickets_splits FROM 's3://nycdsa.ta-am/tickets_splits_2018_09_12.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;

ALTER TABLE stubhub.tickets_splits APPEND FROM working.temp_tickets_splits;


DROP TABLE IF EXISTS working.tickets_df;
DROP TABLE IF EXISTS stubhub.tickets_df;

--TICKETS
CREATE TABLE stubhub.tickets_df(
  dirty_ticket_ind VARCHAR (10),
  dt_accessed VARCHAR (50),
  event_id INTEGER,
  face_value FLOAT (7),
  is_ga BOOLEAN,
  listing_id INTEGER,
  listing_price FLOAT (7),
  quantity INTEGER,
  row_ VARCHAR,
  score FLOAT (5),
  seat_numbers VARCHAR,
  section_id FLOAT (20),
  section_name VARCHAR,
  seller_section_name VARCHAR,
  split_option INTEGER,
  ticket_split INTEGER,
  zone_id FLOAT (20),
  zone_name VARCHAR,
  price_curr FLOAT (7),
  currency_curr CHAR (3),
  price_list FLOAT (20),
  currency_list CHAR (3),
  date_accessed CHAR (10));
 
COPY stubhub.tickets_df FROM 's3://nycdsa.ta-am/tickets_df_2018_09_11.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;

CREATE TABLE working.tickets_df(LIKE stubhub.tickets_df);

COPY working.tickets_df FROM 's3://nycdsa.ta-am/tickets_df_2018_09_08.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;
  
COPY working.tickets_df FROM 's3://nycdsa.ta-am/tickets_df_2018_09_09.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;
  
COPY working.tickets_df FROM 's3://nycdsa.ta-am/tickets_df_2018_09_10.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;

COPY working.tickets_df FROM 's3://nycdsa.ta-am/tickets_df_2018_09_12.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV;

ALTER TABLE stubhub.tickets_df APPEND FROM working.tickets_df;




--EVENTS TICKET SUMMARY
DROP TABLE IF EXISTS stubhub.events_ticket_summary;

CREATE TABLE stubhub.events_ticket_summary(
  minPrice FLOAT (20),
  maxPrice FLOAT (20),
  minListPrice FLOAT (20),
  maxListPrice FLOAT (20),
  originalMinListPrice FLOAT (20),
  totalTickets INTEGER,
  totalPostings INTEGER,
  totalListings INTEGER,
  popularity FLOAT (7),
  currencyCode CHAR (3),
  maxSaleEndDate CHAR (30),
  totalTicketsAtMinPrice FLOAT (7),
  event_id INTEGER,
  dt_accessed TIMESTAMP,
  date_accessed CHAR (10)

);
  
COPY stubhub.events_ticket_summary FROM
      's3://nycdsa.ta-am/events_ticket_summary_2018_09_11.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV 

;

CREATE TABLE working.events_ticket_summary (LIKE stubhub.events_ticket_summary)

; 

COPY working.events_ticket_summary FROM
      's3://nycdsa.ta-am/events_ticket_summary_2018_09_10.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV
 
;

COPY working.events_ticket_summary FROM
      's3://nycdsa.ta-am/events_ticket_summary_2018_09_09.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV
  
;

COPY working.events_ticket_summary FROM
      's3://nycdsa.ta-am/events_ticket_summary_2018_09_08.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV
  
;
COPY working.events_ticket_summary FROM
      's3://nycdsa.ta-am/events_ticket_summary_2018_09_12.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV

;

ALTER TABLE stubhub.events_ticket_summary APPEND FROM working.events_ticket_summary;


DROP TABLE IF EXISTS stubhub.events_df;
DROP TABLE IF EXISTS working.events_df;

--EVENTS DF
CREATE TABLE stubhub.events_df(
  created_date CHAR(30),
  dateOnsale CHAR(30),
  description VARCHAR(1000),
  dt_accessed TIMESTAMP,
  eventDateLocal CHAR(30),
  eventDateUTC CHAR(30),
  eventURL CHAR(500),
  geos CHAR(100),
  event_id INTEGER,
  lastUpdatedDate CHAR(30),
  name VARCHAR(500),
  originalName VARCHAR(500),
  category CHAR(100),
  event_parking BOOL,
  venue_id INTEGER,
  venue_config CHAR(100),
  date_accessed CHAR(10)
);

COPY stubhub.events_df FROM
      's3://nycdsa.ta-am/events_df_2018_09_08.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV

;

CREATE TABLE working.events_df (LIKE stubhub.events_df);

COPY working.events_df FROM
      's3://nycdsa.ta-am/events_df_2018_09_09.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV

;
INSERT INTO stubhub.events_df
SELECT 
  w.*
FROM
  working.events_df w
WHERE
  NOT EXISTS
    (SELECT 
      1
     FROM
      stubhub.events_df p
     WHERE
      p.event_id = w.event_id)
;
TRUNCATE working.events_df;

COPY working.events_df FROM
      's3://nycdsa.ta-am/events_df_2018_09_10.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV

;
INSERT INTO stubhub.events_df
SELECT 
  w.*
FROM
  working.events_df w
WHERE
  NOT EXISTS
    (SELECT 
      1
     FROM
      stubhub.events_df p
     WHERE
      p.event_id = w.event_id)
;
TRUNCATE working.events_df;

COPY working.events_df FROM
      's3://nycdsa.ta-am/events_df_2018_09_11.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV

;
INSERT INTO stubhub.events_df
SELECT 
  w.*
FROM
  working.events_df w
WHERE
  NOT EXISTS
    (SELECT 
      1
     FROM
      stubhub.events_df p
     WHERE
      p.event_id = w.event_id)
;
TRUNCATE working.events_df;
COPY working.events_df FROM
      's3://nycdsa.ta-am/events_df_2018_09_12.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV

;
INSERT INTO stubhub.events_df
SELECT 
  w.*
FROM
  working.events_df w
WHERE
  NOT EXISTS
    (SELECT 
      1
     FROM
      stubhub.events_df p
     WHERE
      p.event_id = w.event_id)
;
TRUNCATE working.events_df;



--EVENTS PERFORMERS
CREATE TABLE stubhub.events_perf(
  dt_accessed TIMESTAMP,
  event_id INTEGER,
  performer_id INTEGER,
  performer_name VARCHAR(500),
  role CHAR(100),
  url VARCHAR(500)
)
;
COPY stubhub.events_perf FROM
      's3://nycdsa.ta-am/events_perf_2018_09_08.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV
;
CREATE TABLE working.events_perf (LIKE stubhub.events_perf)
;
COPY working.events_perf FROM
      's3://nycdsa.ta-am/events_perf_2018_09_09.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV
;
INSERT INTO stubhub.events_perf
SELECT 
  w.*
FROM
  working.events_perf w
WHERE
  NOT EXISTS
    (SELECT 
      1
     FROM
      stubhub.events_perf p
     WHERE
      p.event_id = w.event_id AND
      p.performer_id = w.performer_id)
;
TRUNCATE working.events_perf
;
COPY working.events_perf FROM
      's3://nycdsa.ta-am/events_perf_2018_09_10.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV
;
INSERT INTO stubhub.events_perf
SELECT 
  w.*
FROM
  working.events_perf w
WHERE
  NOT EXISTS
    (SELECT 
      1
     FROM
      stubhub.events_perf p
     WHERE
      p.event_id = w.event_id AND
      p.performer_id = w.performer_id)
;
TRUNCATE working.events_perf
;
COPY working.events_perf FROM
      's3://nycdsa.ta-am/events_perf_2018_09_11.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV
;
INSERT INTO stubhub.events_perf
SELECT 
  w.*
FROM
  working.events_perf w
WHERE
  NOT EXISTS
    (SELECT 
      1
     FROM
      stubhub.events_perf p
     WHERE
      p.event_id = w.event_id AND
      p.performer_id = w.performer_id)
;
TRUNCATE working.events_perf
;
COPY working.events_perf FROM
      's3://nycdsa.ta-am/events_perf_2018_09_12.csv'
  CREDENTIALS 'aws_iam_role=arn:aws:iam::148285915521:role/myRedshiftRole'
  DELIMITER ',' REGION 'us-east-2'
  IGNOREHEADER 1
  CSV
;
INSERT INTO stubhub.events_perf
SELECT 
  w.*
FROM
  working.events_perf w
WHERE
  NOT EXISTS
    (SELECT 
      1
     FROM
      stubhub.events_perf p
     WHERE
      p.event_id = w.event_id AND
      p.performer_id = w.performer_id)
;
TRUNCATE working.events_perf
;

