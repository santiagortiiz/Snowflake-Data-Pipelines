-- Create file format
create or replace file format customer_format
  TYPE = 'CSV'
  FIELD_DELIMITER = '|'
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- Inspect
select $1
from @s3_stage/h_customer.dsv
limit 3;

select $1, $2, $3, $4, $5, REPLACE($6, ',', '.') AS $6, $7, $8
from @s3_stage/h_customer.dsv (file_format => customer_format)
limit 3;

-- Create customer's table
drop table customer;
create table customer
(
  c_custkey    INTEGER not null,
  c_name       VARCHAR(25),
  c_address    VARCHAR(40),
  c_nationkey  INTEGER,
  c_phone      CHAR(15),
  c_acctbal    FLOAT8,
  c_mktsegment CHAR(10),
  c_comment    VARCHAR(117)
);

-- Load data (copy with transformation)
copy into customer
from (
  select
    s3.$1,
    s3.$2,
    s3.$3,
    s3.$4,
    s3.$5,
    REPLACE(s3.$6, ',', '.'),
    s3.$7,
    s3.$8
  from @s3_stage s3
)
files = ('h_customer.dsv')
file_format = (format_name=customer_format);

-- Validate loaded data
select * from customer limit 10;