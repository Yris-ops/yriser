<p align="center">
  <img alt="Yriser logo" src="file/yriser-logo.png" />
</p>

<p align="center">
	<a href="https://github.com/yris-ops/yriser"><img alt="Repo size" src="https://img.shields.io/github/repo-size/yris-ops/yriser"></a>
  <a href="https://github.com/yris-ops/yriser/issues"><img alt="Issues" src="https://img.shields.io/github/issues/yris-ops/yriser"></a>
  <a href="https://github.com/yris-ops/yriser/releases"><img alt="Version" src="https://img.shields.io/github/v/release/yris-ops/yriser?include_prereleases"></a>
  <a href="https://hub.docker.com/r/czantoine/yriser"><img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/czantoine/yriser"></a>
  <a href="https://hub.docker.com/r/czantoine/yriser"><img alt="Docker" src="https://img.shields.io/docker/image-size/czantoine/yriser"></a>
  <a href="https://github.com/yris-ops/yriser/releases"><img alt="Version" src="https://img.shields.io/github/release-date/yris-ops/yriser"></a>
	<a href="https://github.com/yris-ops/yriser"><img alt="Stars" src="https://img.shields.io/github/stars/Yris-ops/yriser"></a>
  <a href="https://github.com/yris-ops/yriser"><img alt="License" src="https://img.shields.io/github/license/yris-ops/yriser"></a>
</p>

<p align="center">
	<a href="https://join.slack.com/t/yrisgroupe/shared_invite/zt-1q51z8dmv-GC0XzUSclzBnUQ0tpKhznw"><img alt="Slack Shield" src="https://img.shields.io/badge/slack-yris-brightgreen.svg?logo=slack"></a>
	<a href="https://twitter.com/cz_antoine"><img alt="Twitter" src="https://img.shields.io/twitter/follow/cz_antoine?style=social"></a>
	<a href="https://www.linkedin.com/in/antoine-cichowicz-837575b1"><img alt="Linkedin" src="https://img.shields.io/badge/-Antoine-blue?style=flat-square&logo=Linkedin&logoColor=white"></a>
</p>

## Description

**Yriser** is an Open Source FinOps tool to perform AWS tagging best practices, tagging strategy, continuous adjustments in cloud optimization.

**Yriser** will help you answer these questions:

* How are tags enforced and what methods and automation will be used (proactive vs reactive)?
* How are tagging effectiveness and goals measured?
* How often should the tagging strategy be reviewed?
* Who drives improvements? How is this done?

## 📃 Documentation

The full documentation can be found at [https://yris-ops.github.io/yriser/](https://yris-ops.github.io/yriser/)

## 🚀 Quick Start

Yriser has been written in Shell using the `jq`, `bc` and AWS CLI.

### From Github

Once Yriser repository is cloned, get into the folder and you can run it:

*Commands:*

``` shell
cd yriser
```

### Configuration file

Edit the configuration file 

``` shell
vi config.txt
```

Below `## TAG KEY` and between `## TAG VALUE` place your tag keys. 

Below `## TAG VALUE` and between `## END` place your tag values.

### Start

Once Yriser repository is cloned, get into the folder and you can run it:

``` shell
./yriser.sh
```

## 🏛️ High level architecture

You can run Yriser from your workstation, an EC2 instance, ECS Fargate or any other container, Codebuild, CloudShell, Cloud9 and many more.

![Archi](docs/img/hight-level-architecture.jpg)

## 🏁 Basic Usage

``` shell
./yriser.sh
```

![Short Display Yriser](docs/img/short-display.png)

> Running the `yriser.sh` script whitout options will use your environment variable credentials.

By default, Yriser will generate a CSV, HTM and JSON reports.

The HTML report will be located in the output directory as the other files and it will look like:

![Report output HTML](docs/tutorials/img/output-html.png)

You can always use -h to access to the usage information and all the possible options:

``` shell
./yriser.sh -h
```

More details at [https://yris-ops.github.io/yriser/](https://yris-ops.github.io/yriser/)

## Docker

Requirements:

* Have `docker` installed: https://docs.docker.com/get-docker/.
* AWS credentials.
* In the command below, change `-v` to your local directory path in order to access the reports.
* Before launching the Docker Image, create your `config.txt` local file.

Commands:

``` bash
docker run -it \
--name yriser \
--env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
--env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
--env AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
-v /your/local/dir/config.txt:/home/yriser/config.txt \
czantoine/yriser:latest
```

Use this command to copy reports locally:

```
docker cp yriser:/home/yriser/output /path/output
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

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

Yriser is licensed as Apache License 2.0 as specified in each file. You may obtain a copy of the License at <http://www.apache.org/licenses/LICENSE-2.0>