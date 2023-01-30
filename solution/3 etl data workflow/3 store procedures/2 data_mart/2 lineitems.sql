-- Store procedure for lineitems
CREATE OR REPLACE PROCEDURE move_lineitem_dwh_to_data_mart()
returns varchar
language sql
as
$$
begin
    BEGIN TRANSACTION;

    INSERT INTO EPAM_LAB.DATA_MART.L_PRICING (
        l_orderkey,
        l_extendedprice,
        l_discount,
        l_tax
    )
    SELECT
        l_orderkey,
        l_extendedprice,
        l_discount,
        l_tax
    FROM EPAM_LAB.CORE_DWH.LINEITEM_CHECK
    WHERE metadata$action = 'INSERT';

    INSERT INTO EPAM_LAB.DATA_MART.L_QUANTITY (
        l_orderkey,
        l_partkey,
        l_suppkey,
        l_linenumber,
        l_quantity
    )
    SELECT
        l_orderkey,
        l_partkey,
        l_suppkey,
        l_linenumber,
        l_quantity
    FROM EPAM_LAB.CORE_DWH.LINEITEM_CHECK
    WHERE metadata$action = 'INSERT';

    INSERT INTO EPAM_LAB.DATA_MART.L_TIME (
        l_orderkey,
        l_shipdate,
        l_commitdate,
        l_receiptdate
    )
    SELECT
        l_orderkey,
        l_shipdate,
        l_commitdate,
        l_receiptdate
    FROM EPAM_LAB.CORE_DWH.LINEITEM_CHECK
    WHERE metadata$action = 'INSERT';

    COMMIT;

    return 'Success';
end;
$$
;
