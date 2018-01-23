# Cloud Metadata Discovery

This container can be run in a cloud environment to attempt to discover metadata about the Cloud Provider from the host.


Right now, only Amazon AWS and Google Cloud are supported. More cloud providers needed.  Please send a Pull Request! :)

## Run

Run such as:

```shell
docker run -it --rm --net=host pinpt/cloud-metadata
```

_NOTE: You'll need to run the container on the host network to get right information._

Will return information as JSON (if found) and exit with `0` or exit with `1` if no cloud provider could be resolved.

Example output for AWS (the actual output will be compressed on one line for easier parsing):

```json
{
  "provider":"amazonec2",
  "public_ipaddress":"50.116.21.11",
  "private_ipaddress":"10.0.1.1",
  "hostname": "ec2-50-116-21-11.us-west-2.compute.amazonaws.com",
  "zone":"us-west-2c",
  "id":"i-9912334",
  "type":"c3.xlarge"
}
```

Example output for Google Cloud Engine (the actual output will be compressed on one line for easier parsing):

```json
{
	"provider":"gce",
	"hostname":"gce-test1.c.foo-9160.internal",
	"public_ipaddress":"114.197.97.113",
	"private_ipaddress":"11.128.0.2",
	"zone":"us-central1-a",
	"id":"9741257677298391091",
	"type":"n1-standard-1"
}
```

## TODO

These https://ahmetalpbalkan.com/blog/comparison-of-instance-metadata-services/ and http://priocept.com/2017/02/12/aws-ec2-vs-google-compute-engine-comparison-instance-metadata/ are helpful

- [ ] Digital Ocean (see https://developers.digitalocean.com/documentation/metadata/)
- [ ] Azure (see https://tickets.puppetlabs.com/browse/FACT-1383)

## License

Copyright (c) 2018 PinPT, Inc. Licensed under the MIT License
