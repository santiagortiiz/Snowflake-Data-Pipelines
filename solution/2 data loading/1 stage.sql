-- Create a Cloud Storage Integration in Snowflake
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::953624878686:role/SnowflakeRole'
  STORAGE_ALLOWED_LOCATIONS = ('s3://epam-lab/raw-data/');

-- Create external stage
create stage s3_stage
  storage_integration = s3_int
  url = 's3://epam-lab/raw-data/';
  -- optional: file_format = tcph_format;

-- Check access
list @s3_stage;