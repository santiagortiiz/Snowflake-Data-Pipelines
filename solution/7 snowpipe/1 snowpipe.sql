-- Architecture
-- S3 -> SQS -> SNS -> Snowpipe

-- Get the SNS policy to allow snowpipe subscribe to a SNS topic
select system$get_aws_sns_iam_policy('arn:aws:sns:us-east-1:953624878686:snowpipe');

-- Create auto ingest pipe
create pipe customer_pipe
    auto_ingest = true
    aws_sns_topic = 'arn:aws:sns:us-east-1:953624878686:snowpipe'
as
copy into customer
from @s3_stage
file_format = (format_name=customer_format);

-- Check the file format used in the pipe
select $1, $2, $3, $4, $5, REPLACE($6, ',', '.') AS $6, $7, $8
from @s3_stage/customer_test_3.dsv (file_format => customer_format)
limit 3;

-- Confirm the loaded data after loading a new file to S3
select * from customer where c_custkey BETWEEN 299500 AND 299515;