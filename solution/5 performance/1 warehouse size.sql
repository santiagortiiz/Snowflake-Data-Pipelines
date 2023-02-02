-- Run SQL queries in warehouses of different zie

-- COMPUTE_WH: X-SMALL: 121 ms
-- SMALL_COMPUTE_WH: SMALL: 30 ms
select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
	l_shipdate >= date('1990-01-01')
	and l_discount between 0.06 - 0.01 and 0.06 + 0.01
    and l_quantity < 20;