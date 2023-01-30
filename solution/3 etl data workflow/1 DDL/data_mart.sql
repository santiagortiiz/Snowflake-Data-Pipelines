-- SCHEMA: DATA_MART

-- Customers
create or replace TABLE EPAM_LAB.DATA_MART.C_NATIONKEY (
	C_CUSTKEY NUMBER(38,0) NOT NULL,
	C_NATIONKEY NUMBER(38,0)
);

create or replace TABLE EPAM_LAB.DATA_MART.C_MKTSEGMENT (
	C_CUSTKEY NUMBER(38,0) NOT NULL,
	C_MKTSEGMENT VARCHAR(10)
);

-- Lineitems
create or replace TABLE EPAM_LAB.DATA_MART.L_PRICING (
  l_orderkey      INTEGER not null,
  l_extendedprice FLOAT8 not null,
  l_discount      FLOAT8 not null,
  l_tax           FLOAT8 not null
);

create or replace TABLE EPAM_LAB.DATA_MART.L_QUANTITY (
  l_orderkey      INTEGER not null,
  l_partkey       INTEGER not null,
  l_suppkey       INTEGER not null,
  l_linenumber    INTEGER not null,
  l_quantity      INTEGER not null
);

create or replace TABLE EPAM_LAB.DATA_MART.L_TIME (
  l_orderkey      INTEGER not null,
  l_shipdate      DATE,
  l_commitdate    DATE,
  l_receiptdate   DATE
);