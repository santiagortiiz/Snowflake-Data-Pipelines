-- Store procedure for customers
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
