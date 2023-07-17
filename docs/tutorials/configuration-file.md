# Configuration file

Edit the configuration file 

``` shell
vi config.txt
```

Below `## TAG KEY` and between `## TAG VALUE` place your tag keys. 

Below `## TAG VALUE` and between `## END` place your tag values.

Here's an example with a tag that you want to associate with multiple rules and a tag that needs to be added to the resource, but you don't have a specific value strategy.

``` txt
## TAG KEY
Environment	
Date
## TAG VALUE
("development" "test" "production")
()
## END
```

We have associated "Environment" with "development" "test" and "production". As for "Date" we cannot associate it with every date of the year, so we leave it blank `()`.

This means that each resource must have the Key "Environment" and the value should be one of these values: "development" "test" or "production." Each resource must have at least the Key "Date."

> Yriser handles special characters in the tag key `:` and `-`.