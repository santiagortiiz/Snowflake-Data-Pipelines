-- Task
CREATE OR REPLACE TASK epam_lab.public.move_lineitems_from_stage_to_dwh
    WAREHOUSE = COMPUTE_WH
    AFTER epam_lab.public.move_data_from_stage_to_dwh
WHEN
    SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK')
AS
    CALL move_lineitem_stage_to_dwh();

-- After creating a task, you must execute ALTER TASK … RESUME
-- before the task will run based on the parameters specified in the task definition.
-- Note that accounts are currently limited to a maximum of 10000 resumed tasks.
ALTER TASK epam_lab.public.move_lineitems_from_stage_to_dwh RESUME;