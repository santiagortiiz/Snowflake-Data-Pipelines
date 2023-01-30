-- Create a stream to track changes in the CUSTOMERS table
CREATE OR REPLACE STREAM customer_check ON TABLE epam_lab.public.customer;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK');

-- Create a table to store the customers in the 3NF schema
create or replace TABLE EPAM_LAB.CORE_DWH.CUSTOMER (
	C_CUSTKEY NUMBER(38,0) NOT NULL,
	C_NAME VARCHAR(25),
	C_ADDRESS VARCHAR(40),
	C_NATIONKEY NUMBER(38,0),
	C_PHONE VARCHAR(15),
	C_ACCTBAL FLOAT,
	C_MKTSEGMENT VARCHAR(10),
	C_COMMENT VARCHAR(117)
);

-- Task
CREATE OR REPLACE TASK customer_to_core_dwh
    WAREHOUSE = COMPUTE_WH
    SUSPEND_TASK_AFTER_NUM_FAILURES = 1
WHEN
    SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK')
AS
    INSERT INTO EPAM_LAB.CORE_DWH.CUSTOMER (
        C_CUSTKEY,
        C_NAME,
        C_ADDRESS,
        C_NATIONKEY,
        C_PHONE,
        C_ACCTBAL,
        C_MKTSEGMENT,
        C_COMMENT
    )
    SELECT
        C_CUSTKEY,
        C_NAME,
        C_ADDRESS,
        C_NATIONKEY,
        C_PHONE,
        C_ACCTBAL,
        C_MKTSEGMENT,
        C_COMMENT
    FROM EPAM_LAB.PUBLIC.CUSTOMER_CHECK
    WHERE metadata$action = 'INSERT';

-- Test data
INSERT INTO EPAM_LAB.PUBLIC.CUSTOMER (C_CUSTKEY, C_NAME) VALUES (631, 'test');

-- Grant execution priviledge
grant execute task on account to role sysadmin;

-- Manually execute task
EXECUTE TASK EPAM_LAB.PUBLIC.customer_to_core_dwh;

-- Check the stream position is advanced
SELECT * FROM EPAM_LAB.PUBLIC.CUSTOMER_CHECK;

-- Task history
select *
from table(information_schema.task_history())
order by scheduled_time;
SELECT * FROM EPAM_LAB.CORE_DWH.CUSTOMER WHERE C_CUSTKEY=631;