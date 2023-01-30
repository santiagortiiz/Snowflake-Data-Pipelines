-- Task
CREATE OR REPLACE TASK epam_lab.public.move_customers_from_dwh_to_data_mart
    WAREHOUSE = COMPUTE_WH
    AFTER epam_lab.public.move_customers_from_stage_to_dwh
WHEN
    SYSTEM$STREAM_HAS_DATA('EPAM_LAB.CORE_DWH.CUSTOMER_CHECK')
AS
    CALL epam_lab.public.move_customer_dwh_to_data_mart();

-- After creating a task, you must execute ALTER TASK … RESUME
-- before the task will run based on the parameters specified in the task definition.
-- Note that accounts are currently limited to a maximum of 10000 resumed tasks.
ALTER TASK epam_lab.public.move_customers_from_dwh_to_data_mart RESUME;