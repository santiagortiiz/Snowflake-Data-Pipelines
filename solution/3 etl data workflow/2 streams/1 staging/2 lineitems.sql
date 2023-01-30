-- Create a stream to track changes in the LINEITEMS table
CREATE OR REPLACE STREAM epam_lab.public.lineitem_check ON TABLE epam_lab.public.lineitem;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.PUBLIC.LINEITEM_CHECK');