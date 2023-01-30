-- Store procedure for customers
CREATE OR REPLACE PROCEDURE move_customer_dwh_to_data_mart()
returns varchar
language sql
as
$$
begin
    BEGIN TRANSACTION;

    INSERT INTO EPAM_LAB.DATA_MART.C_NATIONKEY (
        C_CUSTKEY,
        C_NATIONKEY
    )
    SELECT
        C_CUSTKEY,
        C_NATIONKEY
    FROM EPAM_LAB.CORE_DWH.CUSTOMER_CHECK
    WHERE metadata$action = 'INSERT';

    INSERT INTO EPAM_LAB.DATA_MART.C_MKTSEGMENT (
        C_CUSTKEY,
        C_MKTSEGMENT
    )
    SELECT
        C_CUSTKEY,
        C_MKTSEGMENT
    FROM EPAM_LAB.CORE_DWH.CUSTOMER_CHECK
    WHERE metadata$action = 'INSERT';

    COMMIT;

    return 'Success';
end;
$$
;
