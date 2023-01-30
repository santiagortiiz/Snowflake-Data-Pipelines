-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK');

-- Insert new data
INSERT INTO EPAM_LAB.PUBLIC.CUSTOMER (C_CUSTKEY, C_NAME) VALUES (631, 'test A');

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK');

-- Manually execute the task
EXECUTE TASK EPAM_LAB.PUBLIC.move_customers_from_stage_to_dwh;

-- Check the stream position is advanced
SELECT * FROM EPAM_LAB.PUBLIC.CUSTOMER_CHECK;

-- Task history
select *
from table(information_schema.task_history())
order by scheduled_time;
SELECT * FROM EPAM_LAB.CORE_DWH.CUSTOMER WHERE C_CUSTKEY=631;