-- Schema: CORE_DWH

-- Customers
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

-- Lineitems
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