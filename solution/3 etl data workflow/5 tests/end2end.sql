-- Insert new data
INSERT INTO EPAM_LAB.PUBLIC.CUSTOMER (C_CUSTKEY, C_NAME, C_ADDRESS, C_NATIONKEY, C_PHONE, C_ACCTBAL, C_MKTSEGMENT, C_COMMENT)
    VALUES (633, 'test A', 'address', 631, '3127518213', 1.9, 'tech', 'fake data');

INSERT INTO EPAM_LAB.PUBLIC.LINEITEM (
    l_orderkey,
    l_partkey,
    l_suppkey,
    l_linenumber,
    l_quantity,
    l_extendedprice,
    l_discount,
    l_tax,
    l_shipdate,
    l_commitdate,
    l_receiptdate
) VALUES (633, 1, 2, 3, 4, 5.0, 6.0, 7.0, '31-01-2023', '31-01-2023', '31-01-2023');

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK');
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK');

-- Manually execute the task
EXECUTE TASK EPAM_LAB.PUBLIC.move_data_from_stage_to_dwh;

-- Check the stream position is advanced
SELECT * FROM EPAM_LAB.PUBLIC.CUSTOMER_CHECK;

-- Task history
select *
from table(information_schema.task_history())
order by scheduled_time;

-- Confirm results
SELECT * FROM EPAM_LAB.CORE_DWH.CUSTOMER WHERE C_CUSTKEY=633;
SELECT * FROM EPAM_LAB.CORE_DWH.LINEITEM WHERE l_orderkey=633;

SELECT * FROM EPAM_LAB.DATA_MART.C_MKTSEGMENT WHERE C_CUSTKEY=633;
SELECT * FROM EPAM_LAB.DATA_MART.C_NATIONKEY WHERE C_CUSTKEY=633;

SELECT * FROM EPAM_LAB.DATA_MART.L_PRICING WHERE l_orderkey=633;
SELECT * FROM EPAM_LAB.DATA_MART.L_QUANTITY WHERE l_orderkey=633;
SELECT * FROM EPAM_LAB.DATA_MART.L_TIME WHERE l_orderkey=633;

