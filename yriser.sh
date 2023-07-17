#!/bin/bash
# Authored by Antoine CICHOWICZ
# Copyright: Apache License 2.0
# Yriser - https://github.com/yris-ops/yriser

export VERSION="0.0.0-Moof-3June2023"
REGION_LIST="allregions"
show_banner=true
specific_aws_profile=true
config_file="config.txt"
export PATH_DATE=$(date +"%Y%m%d%H%M%S")
export cli_output_html="yes"
export cli_output_csv="yes"

# Display Help
COMMAND_LINE_OPTIONS_HELP='
usage: ./yriser.sh -h

Command line options:
    -h,   show general help
    -v,   show Yriser version
    -b,   hide Yriser banner
    -c,   show config file
    -w,   show config file
    -o,   only cli output whiout html
    -u,   only cli output whiout csv

Yriser Available Cloud Providers:
    -a,,  show AWS Provider help

Detailed documentation at https://www.docs.yriser.com
'

# Display AWS Help
COMMAND_LINE_OPTIONS_HELP_AWS='
usage: ./yriser.sh -a

Command line options:
    -r,   scan specific AWS Region
    -p,   use AWS Profile

AWS Regions:
us-east-1 us-east-2 us-west-1 us-west-2 af-south-1 ap-east-1 ap-south-2 ap-southeast-3 ap-southeast-4 ap-south-1 ap-northeast-1 ap-northeast-2 ap-northeast-3 ap-northeast-4 ap-northeast-1 ca-central-1 eu-central-1 eu-central-2 eu-west-1 eu-west-2 eu-west-3 eu-south-1 eu-south-2 eu-north-1 sa-east-1 me-central-1 us-gov-east-1 us-gov-west-1
    AWS region names to run Yriser against

Detailed documentation at https://www.docs.yriser.com
'

# Display Version
Version()
{
    echo "Yriser $VERSION"
}

# Specific region(s)
Region()
{
    IFS=' ' read -ra REGION_ARRAY <<< "$OPTARG"
    REGION_LIST=("${REGION_ARRAY[@]}")
    for val in "${REGION_LIST[@]}"; do
        region_getopts_list+=$(echo " \"$val\"")
    done
}

# Only CLI Input without HTLM
CLI_html(){
    export cli_output_html="no"
}

# Only CLI Input without CSV
CLI_csv(){
    export cli_output_csv="no"
}

Config()
{
    echo "Configuration file:"
    echo
    grep -E "^[[:alpha:]\-]+:" $config_file | sed 's/$/     ->  /' | paste -d ' ' - <(grep -o '([^)]*)' $config_file | sed 's/[()]//g' | sed 's/"//g')
}

# Specific AWS Profile
Profile_AWS()
{
    AWS_PROFIL+="$OPTARG"
    SSO_ACCOUNT_PROFILE=$(aws sts get-caller-identity --query "Account" --profile $AWS_PROFIL 2> /dev/null)
    SSO_ACCOUNT=$(aws sts get-caller-identity --profile $AWS_PROFIL --query "Account" 2> /dev/null)
    AWSACCOUNT=$(echo $SSO_ACCOUNT | tr -d '"')
    SSO_USERID=$(aws sts get-caller-identity --profile $AWS_PROFIL --query "UserId" 2> /dev/null)
    AWSUSERID=$(echo $SSO_USERID | tr -d '"')
    SSO_ARN=$(aws sts get-caller-identity --profile $AWS_PROFIL --query "Arn" 2> /dev/null)
    AWSARN=$(echo $SSO_ARN | tr -d '"')
}

while getopts "h/a/v/b/c/o/u/y/r:/p:" option; do
    case $option in
      h) # display help
         echo "$COMMAND_LINE_OPTIONS_HELP"
         exit;;
      a) # display aws help
         echo "$COMMAND_LINE_OPTIONS_HELP_AWS"
         exit;;
      v) # display version
         Version
         exit;;
      b) # display Banner
         show_banner=false
         ;;
      o) # only cli output without html
         CLI_html
         ;;
      u) # only cli output without csv
         CLI_csv
         ;;
      c) # display config file
         Config
         exit;;
      r) # specific region(s)
         Region
         ;;
      p) # specific aws profider profile
         specific_aws_profile=false
         Profile_AWS
         ;;
      \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
    esac
done

if [ "$cli_output_csv" = "no" ]; then
    if [ "$cli_output_html" = "yes" ]; then
        echo "Please disable: Output without CSV (command -u) for the HTML output"
        exit
    fi
fi

if $show_banner; then
    cat file/logo.txt
fi

# Create output folder for first time scan with redirected stout
mkdir -p output
mkdir -p output/txt
mkdir -p output/csv
mkdir -p output/html

REGION_LIST_AWS=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "af-south-1" "ap-east-1" "ap-south-2" "ap-southeast-3" "ap-southeast-4" "ap-south-1" "ap-northeast-1" "ap-northeast-2" "ap-northeast-3" "ap-northeast-4" "ap-northeast-1" "ca-central-1" "eu-central-1" "eu-central-2" "eu-west-1" "eu-west-2" "eu-west-3" "eu-south-1" "eu-south-2" "eu-north-1" "sa-east-1" "me-central-1" "us-gov-east-1" "us-gov-west-1")

current_date=$(date +"%Y-%m-%d %H:%M:%S")
echo -e "\033[1;33mDate: $current_date\033[0m"

if $specific_aws_profile; then
    SSO_ACCOUNT_PROFILE=$(aws sts get-caller-identity --query "Account" --profile $AWS_PROFIL 2> /dev/null)
    SSO_ACCOUNT=$(aws sts get-caller-identity --query "Account" 2> /dev/null)
    AWSACCOUNT=$(echo $SSO_ACCOUNT | tr -d '"')
    SSO_USERID=$(aws sts get-caller-identity --query "UserId" 2> /dev/null)
    AWSUSERID=$(echo $SSO_USERID | tr -d '"')
    SSO_ARN=$(aws sts get-caller-identity --query "Arn" 2> /dev/null)
    AWSARN=$(echo $SSO_ARN | tr -d '"')
fi

export AWSUSERID="$AWSUSERID"
export AWSARN="$AWSARN"

if [ ${#SSO_ACCOUNT_PROFILE} -eq 14 ] || [ ${#SSO_ACCOUNT} -eq 14 ] || aws sts get-caller-identity &> /dev/null; then
    echo -e "\033[0;36mAWS Session still valid\033[0m"
    echo ""
else
    echo -e "\033[0;31mSeems like AWS session expired\033[0m"
    exit 1
fi
echo "This report is being generated using credentials below:"
echo ""
echo -ne "AWS-CLI Profile: "
if [ "$AWS_PROFIL" == "" ]; then
    echo -ne "\033[33m[default] \033[0m"
else
    echo -ne "\033[33m[$AWS_PROFIL] \033[0m"
fi
echo -ne "AWS Filter region: "
if [ "$REGION_LIST" == "allregions" ]; then
    echo -e "\033[33m[all AWS regions]\033[0m"
else
    echo -e "\033[33m[regions list]\033[0m"
fi
echo -ne "AWS Account: "
echo -ne "\033[33m[$AWSACCOUNT] \033[0m"
echo -ne "User Id: "
echo -e "\033[33m[$AWSUSERID]\033[0m"
echo -ne "Caller Identity ARN: "
echo -e "\033[33m[$AWSARN]\033[0m"
echo ""

if [ ${#SSO_ACCOUNT_PROFILE} -eq 14 ]; then
    if [ "$REGION_LIST" == "allregions" ]; then
        for region in "${REGION_LIST_AWS[@]}"
        do
            for account in "${AWSACCOUNT[@]}"
            do
                echo "AWS Account ${AWSACCOUNT[@]} [$region] being processed"
                aws resourcegroupstaggingapi get-resources --output text --region $region --profile $AWS_PROFIL >> output/yriser-$account-$PATH_DATE-$region.txt
                echo "AWS Account ${AWSACCOUNT[@]} [$region] has been processed"
                cp report_tag.sh output/
                mv output/report_tag.sh output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh
                echo "AWS Account ${AWSACCOUNT[@]} [$region] ready for scanning"
                echo ""
                path=$(echo output/yriser-$account-$PATH_DATE-$region)
                path=$(echo "$path"_report_tag.sh)
                bash generate.sh $path
                bash output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh output/yriser-$account-$PATH_DATE-$region.txt yriser-$account-$PATH_DATE-$region yriser-$account-$PATH_DATE-$region.csv $account $region
                rm output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh
                rm output/yriser-$account-$PATH_DATE-$region.txt
                rm -rf output/txt/*
            done
        done
    else
        for region in "${REGION_LIST[@]}"
        do
            for account in "${AWSACCOUNT[@]}"
            do
                echo "AWS Account ${AWSACCOUNT[@]} [$region] being processed"
                aws resourcegroupstaggingapi get-resources --output text --region $region --profile $AWS_PROFIL >> output/yriser-$account-$PATH_DATE-$region.txt
                echo "AWS Account ${AWSACCOUNT[@]} [$region] has been processed"
                cp report_tag.sh output/
                mv output/report_tag.sh output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh
                echo "AWS Account ${AWSACCOUNT[@]} [$region] ready for scanning"
                echo ""
                path=$(echo output/yriser-$account-$PATH_DATE-$region)
                path=$(echo "$path"_report_tag.sh)
                bash generate.sh $path
                bash output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh output/yriser-$account-$PATH_DATE-$region.txt yriser-$account-$PATH_DATE-$region yriser-$account-$PATH_DATE-$region.csv $account $region
                rm output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh
                rm output/yriser-$account-$PATH_DATE-$region.txt
                rm -rf output/txt/*
            done
        done
    fi
fi

if [ ${#SSO_ACCOUNT} -eq 14 ] || aws sts get-caller-identity &> /dev/null; then
    if [ "$REGION_LIST" == "allregions" ]; then
        for region in "${REGION_LIST_AWS[@]}"
        do
            for account in "${AWSACCOUNT[@]}"
            do
                echo "AWS Account ${AWSACCOUNT[@]} [$region] being processed"
                aws resourcegroupstaggingapi get-resources --output text --region $region >> output/yriser-$account-$PATH_DATE-$region.txt
                echo "AWS Account ${AWSACCOUNT[@]} [$region] has been processed"
                cp report_tag.sh output/
                mv output/report_tag.sh output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh
                echo "AWS Account ${AWSACCOUNT[@]} [$region] ready for scanning"
                echo ""
                path=$(echo output/yriser-$account-$PATH_DATE-$region)
                path=$(echo "$path"_report_tag.sh)
                bash generate.sh $path
                bash output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh output/yriser-$account-$PATH_DATE-$region.txt yriser-$account-$PATH_DATE-$region yriser-$account-$PATH_DATE-$region.csv $account $region
                rm output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh
                rm output/yriser-$account-$PATH_DATE-$region.txt
                rm -rf output/txt/*
            done
        done
    else
        for region in "${REGION_LIST[@]}"
        do
            for account in "${AWSACCOUNT[@]}"
            do
                echo "AWS Account ${AWSACCOUNT[@]} [$region] being processed"
                aws resourcegroupstaggingapi get-resources --output text --region $region >> output/yriser-$account-$PATH_DATE-$region.txt
                echo "AWS Account ${AWSACCOUNT[@]} [$region] has been processed"
                cp report_tag.sh output/
                mv output/report_tag.sh output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh
                echo "AWS Account ${AWSACCOUNT[@]} [$region] ready for scanning"
                echo ""
                path=$(echo output/yriser-$account-$PATH_DATE-$region)
                path=$(echo "$path"_report_tag.sh)
                bash generate.sh $path
                bash output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh output/yriser-$account-$PATH_DATE-$region.txt yriser-$account-$PATH_DATE-$region yriser-$account-$PATH_DATE-$region.csv $account $region
                rm output/yriser-$account-$PATH_DATE-"$region"_report_tag.sh
                rm output/yriser-$account-$PATH_DATE-$region.txt
                rm -rf output/txt/*
            done
        done
    fi
fi 

rm -rf output/txt