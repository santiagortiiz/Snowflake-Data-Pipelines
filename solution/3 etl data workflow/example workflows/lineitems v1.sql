-- Create a stream to track changes in the CUSTOMERS table
CREATE OR REPLACE STREAM epam_lab.public.lineitem_check ON TABLE epam_lab.public.lineitem;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK');

-- Create a table to store the customers in the 3NF schema
create or replace TABLE EPAM_LAB.CORE_DWH.LINEITEM (
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

-- Task
CREATE OR REPLACE TASK lineitem_to_core_dwh
    WAREHOUSE = COMPUTE_WH
    SUSPEND_TASK_AFTER_NUM_FAILURES = 1
WHEN
    SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK')
AS
    INSERT INTO EPAM_LAB.CORE_DWH.LINEITEM (
        l_orderkey,
        l_partkey,
        l_suppkey,
        l_linenumber,
        l_quantity,
        l_extendedprice,
        l_discount,
        l_tax,
        l_returnflag,
        l_linestatus,
        l_shipdate,
        l_commitdate,
        l_receiptdate,
        l_shipinstruct,
        l_shipmode,
        l_comment
    )
    SELECT
        l_orderkey,
        l_partkey,
        l_suppkey,
        l_linenumber,
        l_quantity,
        l_extendedprice,
        l_discount,
        l_tax,
        l_returnflag,
        l_linestatus,
        l_shipdate,
        l_commitdate,
        l_receiptdate,
        l_shipinstruct,
        l_shipmode,
        l_comment
    FROM EPAM_LAB.PUBLIC.LINEITEM_CHECK
    WHERE metadata$action = 'INSERT';

-- Test data
INSERT INTO EPAM_LAB.PUBLIC.LINEITEM (
    l_orderkey,
    l_partkey,
    l_suppkey,
    l_linenumber,
    l_quantity,
    l_extendedprice,
    l_discount,
    l_tax
) VALUES (631, 1, 2, 3, 4, 5.0, 6.0, 7.0);

-- Grant execution priviledge
grant execute task on account to role sysadmin;

-- Manually execute task
EXECUTE TASK EPAM_LAB.PUBLIC.lineitem_to_core_dwh;

-- Check the stream position is advanced
SELECT * FROM EPAM_LAB.PUBLIC.LINEITEM_CHECK;

-- Task history
select *
from table(information_schema.task_history())
order by scheduled_time;

-- Check inserted row
select * from EPAM_LAB.CORE_DWH.LINEITEM where l_orderkey=631;