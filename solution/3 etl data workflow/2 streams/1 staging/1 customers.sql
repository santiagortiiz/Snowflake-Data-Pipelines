-- Create a stream to track changes in the CUSTOMERS table
CREATE OR REPLACE STREAM epam_lab.public.customer_check ON TABLE epam_lab.public.customer;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.CUSTOMER_CHECK');