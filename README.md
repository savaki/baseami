baseami
=======

Builds the base AMI usable by various projects

### Required Environment Variables

Base AMI is configured via the use of environment variables.  The following environment variables:

|Name|Required|Description|
| :--- | :----: | :------ |
|AWS_ACCESS_KEY_ID|yes|aws credential|
|AWS_SECRET_ACCESS_KEY|yes|aws credential|
|AMI_USER|yes|the user that will be created within the AMI|
|AMI_BUCKET|yes|the name of the bucket baseami should to mount an S3 bucket as a debian repo|
|AMI_ID|no|the initial ami to use.  defaults to ami-70f96e40|
|AMI_REGION|no|which region the AMI should be created in (default: us-west-2)|

## artifact.json

Once successful completion, baseami creates a json file that contains the following data:

```
{
  "name": "baseami",
  "build": "51",
  "ami": "ami-515ecc61"
}
```
