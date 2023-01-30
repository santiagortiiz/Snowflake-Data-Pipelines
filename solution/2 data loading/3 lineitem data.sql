-- Create file format
create or replace file format lineitem_format
  TYPE = 'CSV'
  FIELD_DELIMITER = '|'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  TRIM_SPACE = TRUE;

-- Inspect
select $1
from @s3_stage/h_lineitem.dsv
limit 3;

select $1, $2, $3, $4, $5,
    REPLACE($6, ',', '.'), REPLACE($7, ',', '.'), REPLACE($8, ',', '.'),
    $9, $10,
    DATE($11, 'DD.MM.YY'), DATE($12, 'DD.MM.YY'), DATE($13, 'DD.MM.YY'),
    $14, $15, $16
from @s3_stage/h_lineitem.dsv (file_format => lineitem_format)
limit 3;

-- Create lineitem's table
drop table lineitem;
create table lineitem
(
  l_orderkey      INTEGER not null,
  l_partkey       INTEGER not null,
  l_suppkey       INTEGER not null,
  l_linenumber    INTEGER not null,
  l_quantity      INTEGER not null,
  l_extendedprice FLOAT8 not null,
  l_discount      FLOAT8 not null,
  l_tax           FLOAT8 not null,
  l_returnflag    CHAR(1),
  l_linestatus    CHAR(1),
  l_shipdate      DATE,
  l_commitdate    DATE,
  l_receiptdate   DATE,
  l_shipinstruct  CHAR(25),
  l_shipmode      CHAR(10),
  l_comment       VARCHAR(44)
);

-- Load data
copy into lineitem
from (
    select
        s3.$1, s3.$2, s3.$3, s3.$4, s3.$5,
        REPLACE(s3.$6, ',', '.'), REPLACE(s3.$7, ',', '.'), REPLACE(s3.$8, ',', '.'),
        s3.$9, s3.$10,
        DATE(s3.$11, 'DD.MM.YY'), DATE(s3.$12, 'DD.MM.YY'), DATE(s3.$13, 'DD.MM.YY'),
        s3.$14, s3.$15, s3.$16
    from @s3_stage s3
)
files = ('h_lineitem.dsv')
file_format = (format_name=lineitem_format);

-- Validate loaded data
select * from lineitem limit 10;