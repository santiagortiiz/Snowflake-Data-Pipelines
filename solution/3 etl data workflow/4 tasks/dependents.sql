select *
from table (
    information_schema.task_dependents (
        task_name => 'move_data_from_stage_to_dwh',
        recursive => true
    )
);