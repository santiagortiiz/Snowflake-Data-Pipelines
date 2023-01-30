-- Create a stream to track changes in the LINEITEMS table
CREATE OR REPLACE STREAM epam_lab.core_dwh.lineitem_check ON TABLE epam_lab.core_dwh.lineitem;

-- Check stream status
SELECT SYSTEM$STREAM_HAS_DATA('EPAM_LAB.CORE_DWH.LINEITEM_CHECK');