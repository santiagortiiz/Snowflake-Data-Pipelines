-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK');

-- Insert new data
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

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK');

-- Manually execute the task
EXECUTE TASK EPAM_LAB.PUBLIC.move_lineitems_from_stage_to_dwh;

-- Check the stream position is advanced
SELECT * FROM EPAM_LAB.PUBLIC.LINEITEM_CHECK;

-- Task history
select *
from table(information_schema.task_history())
order by scheduled_time;
SELECT * FROM EPAM_LAB.CORE_DWH.LINEITEM WHERE l_orderkey=631;