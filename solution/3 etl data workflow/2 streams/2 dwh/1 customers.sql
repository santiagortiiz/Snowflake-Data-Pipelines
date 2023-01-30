-- Create a stream to track changes in the CUSTOMERS table
CREATE OR REPLACE STREAM epam_lab.core_dwh.customer_check ON TABLE epam_lab.core_dwh.customer;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.CORE_DWH.CUSTOMER_CHECK');