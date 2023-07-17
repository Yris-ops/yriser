<p href="https://github.com/Yriser-cloud/Yriser">
<img align="right" src="./img/yriser-logo.png" height="100">
</p>
<br>

# Yriser Documentation

<br><br>

**Welcome to [Yriser Open Source](https://github.com/yris-ops/yriser/) Documentation!** 📄

You are currently in the Getting Started section where you can find general information and requirements to help start with the tool.

* In the [Tutorials](tutorials/command) section you will see how to take advantage of all the features in Yriser.
* In the [Best Practices](tutorials/best-pratices/build) section you will see who implement a tagging strategy.
* In the [Contact Us](contact) section you can find how to reach us out in case of technical issues.
* In the [About](about) section you will find more information about the Yriser team and license.

## About Yriser

**Yriser** is an Open Source FinOps tool to perform AWS tagging best practices, tagging strategy, continuous adjustments in cloud optimization.

**Yriser** will help you answer these questions:

* How are tags enforced and what methods and automation will be used (proactive vs reactive)?
* How are tagging effectiveness and goals measured?
* How often should the tagging strategy be reviewed?
* Who drives improvements? How is this done?

[![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/toniblyx.svg?style=social&label=Follow%20%40cz_antoine)](https://twitter.com/cz_antoine)
<a href="https://www.linkedin.com/in/antoine-cichowicz-837575b1"><img alt="Linkedin" src="https://img.shields.io/badge/-Antoine-blue?style=flat-square&logo=Linkedin&logoColor=white"></a>

## Quick Start

Yriser has been written in Shell using the `jq`, `bc` and AWS CLI.

> See [Requirements](getting-started/requirements) section to install `jq`, `bc` and AWS CLI.

### Installation

Once Yriser repository is cloned, get into the folder and you can run it:

=== "Generic"

    _Requirements_:

    * `jq`
    * `bc`
    * `aws cli`
    * AWS credentials

    _Commands_:

    ``` bash
    git clone https://github.com/yris-ops/yriser
    chmod -R +x yriser/
    cd yriser
    ./yriser.sh -v
    ```

=== "macOS"

    _Requirements_:

    * `brew install jq`
    * `brew install bc`
    * `aws cli`
    * AWS credentials

    _Commands_:

    ``` bash
    git clone https://github.com/yris-ops/yriser
    chmod -R +x yriser/
    cd yriser
    ./yriser.sh -v
    ```

=== "Amazon Linux 2"

    _Requirements_:

    * `sudo yum install jq`
    * `sudo yum install bc`
    * AWS credentials

    _Commands_:

    ``` bash
    git clone https://github.com/yris-ops/yriser
    chmod -R +x yriser/
    cd yriser
    ./yriser.sh -v
    ```

=== "AWS CloudShell"

    _Requirements_:

    * `sudo yum install jq`
    * `sudo yum install bc`
    * AWS credentials

    _Commands_:

    ``` bash
    git clone https://github.com/yris-ops/yriser
    chmod -R +x yriser/
    cd yriser
    ./yriser.sh -v
    ```

### Configuration file 

Edit the configuration file 

``` shell
vi config.txt
```

Below `## TAG KEY` and between `## TAG VALUE` place your tag keys. 

Below `## TAG VALUE` and between `## END` place your tag values.

More options and executions methods that will save your time in [Configuration file](tutorials/configuration-file)

## High level architecture

You can run Yriser from your workstation, an EC2 instance, ECS Fargate or any other container, Codebuild, CloudShell, Cloud9 and many more.

![Archi](/img/hight-level-architecture.jpg)

## Basic Usage

``` shell
./yriser.sh
```

![Short Display Yriser](img/short-display.png)

> Running the `yriser.sh` script whitout options will use your environment variable credentials, see [Requirements](getting-started/requirements) section to review the credentials settings.

By default, Yriser will generate a CSV and HTM reports.

The HTML report will be located in the output directory as the other files and it will look like:

![Report output HTML](tutorials/img/output-html.png)

More options and executions methods that will save your time in [Commands](tutorials/command)

You can always use -h to access to the usage information and all the possible options:

``` shell
./yriser.sh -h
```

### AWS

You can always use -a to access to the usage information and all the possible options:

``` shell
./yriser.sh -a
```

Use a custom AWS profile with -p and/or AWS regions which you want to audit with -r:

``` shell
./yriser.sh -p <aws_profile> -r "us-east-1 eu-west-1"
```

> By default, Yriser will scan all AWS regions.

See more details about AWS Authentication in [Requirements](getting-started/requirements).