# Command

## Help

Display help documentation:

``` shell
./yriser.sh -h
```

## Yriser Version 

Show Yriser version:

``` shell
./yriser.sh -v
```

## Hide Yriser Banner

Yriser can run without showing its banner:

``` shell
./yriser.sh -b
```

## Display Configuration file

Show `config.txt` file:

``` shell
./yriser.sh -c
```
## Disable HTML output

Only CLI Input without HTML

``` shell
./yriser.sh -o
```

> Do not disable output without CSV (command -u) for the HTML outputs

## Disable CSV output

Only CLI Input without CSV

``` shell
./yriser.sh -u
```

## Disable JSON output

Only CLI Input without JSON.

``` shell
./yriser.sh -j
```

> Do not disable output without CSV (command -u) for the JSON outputs

## Slack

Send report result to Slack

``` shell
./yriser.sh -w <webhook_token>
```

## AWS

### AWS - Display help documentation

Display help documentation for AWS provider:

``` shell
./yriser.sh -a
```

### Scan specific AWS Region

Yriser can scan specific region(s) with:

``` shell
./yriser.sh -r "us-east-1 eu-west-1"
```

### Use AWS Profile

Yriser can use your custom AWS Profile with:

``` shell
./yriser.sh -p <aws_profile>
```

### Send report to AWS S3 Bucket

To save your report in an S3 bucket, use -s to be uploaded to S3:

``` shell
./yriser.sh -s bucket-yriser-demo
```