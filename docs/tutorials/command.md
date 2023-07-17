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