-- 3NF

-- COMPUTE_WH: X-SMALL: 102 ms
-- SMALL_COMPUTE_WH: SMALL: 46 ms
SELECT *
FROM lineitem
LIMIT 1000;


-- STAR SCHEMA

-- COMPUTE_WH: X-SMALL: 2.9 s
-- SMALL_COMPUTE_WH: SMALL:  117 ms
SELECT *
FROM L_PRICING lp
JOIN L_QUANTITY lq
    ON lp.l_orderkey = lq.l_orderkey
JOIN L_TIME lt
    ON lp.l_orderkey = lt.l_orderkey
LIMIT 10