-- 1 Create a stream to track changes in the CUSTOMERS table
CREATE OR REPLACE STREAM customer_check ON TABLE epam_lab.public.customer;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK');

-- 2 Store procedure for customers
CREATE OR REPLACE PROCEDURE move_customer_stage_to_dwh()
returns varchar
language sql
as
$$
begin
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

    return 'Success';
end;
$$
;

-- 3 Task
CREATE OR REPLACE TASK epam_lab.public.move_customers_from_stage_to_dwh
    WAREHOUSE = COMPUTE_WH
    SUSPEND_TASK_AFTER_NUM_FAILURES = 1
WHEN
    SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK')
AS
    CALL move_customer_stage_to_dwh();

-- 4 TEST
-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK');

-- Insert new data
INSERT INTO EPAM_LAB.PUBLIC.CUSTOMER (C_CUSTKEY, C_NAME) VALUES (631, 'test A');
SELECT * FROM EPAM_LAB.PUBLIC.CUSTOMER WHERE C_CUSTKEY=631;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK');
SELECT * FROM EPAM_LAB.PUBLIC.CUSTOMER_CHECK;

-- Manually execute the task
EXECUTE TASK EPAM_LAB.PUBLIC.move_customers_from_stage_to_dwh;

-- Check the stream position is advanced
SELECT * FROM EPAM_LAB.PUBLIC.CUSTOMER_CHECK;

-- Task history
select *
from table(information_schema.task_history())
order by scheduled_time;
SELECT * FROM EPAM_LAB.CORE_DWH.CUSTOMER WHERE C_CUSTKEY=631;
