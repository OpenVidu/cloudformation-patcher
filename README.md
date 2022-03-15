# Cloudformation patcher

This tool allows to generate Cloudformations based on:

- A **Cloudformation file**
- A YAML formatted file which describes changes applied to the original Cloudformation.
# How the parser works and how to execute it?

Let's suppose a basic Cloudformation file

- **`cf-example.yaml`**
```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: Example
Resources:
  ConfidentialBucket:
    Type: AWS::S3::Bucket
    Properties:
      AccessControl: PublicRead
  NotUsefulBucket:
    Type: AWS::S3::Bucket
    Properties:
      AccessControl: PublicRead
```

We want to:

- Make `Confidential` bucket a private Bucket
- Remove `NotUsefulBucket`
- Create a `NewBucket`

Instead of manually editing the file, let's create a patch file with a special YAML format like this:

- **`patch-example.yaml`**

```yaml
Patches:
  # ================
  # Change 'Confidential' bucket to private
  # ================
  - AddOrUpdate:
      Location: .Resources.ConfidentialBucket.Properties.AccessControl
      Content: Private
  # ================
  # Create new bucket: 'NewBucket'
  # ================
  - AddOrUpdate:
      Location: .Resources.ConfidentialBucket.NewBucket
      Content:
        Type: AWS::S3::Bucket
        Properties:
          AccessControl: PublicRead
  # ================
  # Remove 'NotUsefulBucket'
  # ================
  - Remove:
      Location: .Resources.ConfidentialBucket.NotUsefulBucket
```

First you need the docker image build on your system (You need Docker installed):

To generate the final Cloudformation file, we just need to execute:

```
docker run --rm -it -v "${PWD}":/workdir \
  openvidu/cloudformation-patcher \
  --original example/cf-example.yaml \
  --patch example/patch-example.yaml \
  --output example/output.yaml
```

And this will generate at `example/output.yml` the final Cloudformation with all the changes:

```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: Example
Resources:
  ConfidentialBucket:
    Type: AWS::S3::Bucket
    Properties:
      AccessControl: Private
  NewBucket:
    Type: AWS::S3::Bucket
    Properties:
      AccessControl: PublicRead
```

# Modify and build the tool.

To modify the docker image of the tool, you just need to modify the script at `docker/cloudformation-patcher` and build the image with:

```
./create_image.sh
```

Or just build the image with:

```
docker build . -t openvidu/cloudformation-patcher
```