-- 1 Create a stream to track changes in the LINEITEMS table
CREATE OR REPLACE STREAM epam_lab.public.lineitem_check ON TABLE epam_lab.public.lineitem;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK');

-- 2 Store procedure for lineitems
CREATE OR REPLACE PROCEDURE move_lineitem_stage_to_dwh()
returns varchar
language sql
as
$$
begin
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

    return 'Success';
end;
$$
;

-- 3 Task
CREATE OR REPLACE TASK epam_lab.public.move_lineitems_from_stage_to_dwh
    WAREHOUSE = COMPUTE_WH
    SUSPEND_TASK_AFTER_NUM_FAILURES = 1
WHEN
    SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK')
AS
    CALL move_lineitem_stage_to_dwh();

-- 4 TEST
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