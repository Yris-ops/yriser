#!/bin/bash
# Authored by Antoine CICHOWICZ
# Copyright: Apache License 2.0
# Yriser - https://github.com/yris-ops/yriser

export VERSION="0.0.3-SantaFe-22September2023"
REGION_LIST="allregions"
show_banner=true
specific_aws_profile=true
s3_aws_profile=false
config_file="config.txt"
export PATH_DATE=$(date +"%Y%m%d%H%M%S")
export cli_output_html="yes"
export cli_output_csv="yes"
export cli_output_json="yes"

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
    -j,   only cli output whiout json
    -w,   send report result to slack

Yriser Available Cloud Providers:
    -a,  show AWS Provider help

Detailed documentation at https://yris-ops.github.io/yriser/
'

# Display AWS Help
COMMAND_LINE_OPTIONS_HELP_AWS='
usage: ./yriser.sh -a

Command line options:
    -r,   scan specific AWS Region
    -p,   use AWS Profile
    -s,   send report to AWS S3 Bucket

AWS Regions:
us-east-1 us-east-2 us-west-1 us-west-2 af-south-1 ap-east-1 ap-south-2 ap-southeast-3 ap-southeast-4 ap-south-1 ap-northeast-1 ap-northeast-2 ap-northeast-3 ap-northeast-4 ap-northeast-1 ca-central-1 eu-central-1 eu-central-2 eu-west-1 eu-west-2 eu-west-3 eu-south-1 eu-south-2 eu-north-1 sa-east-1 me-central-1 us-gov-east-1 us-gov-west-1
    AWS region names to run Yriser against

Detailed documentation at https://yris-ops.github.io/yriser/
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

# Only CLI Input without JSON
CLI_json(){
    export cli_output_json="no"
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

# Send output in AWS S3
S3()
{
    echo
    echo "Upload into the bucket: $AWS_S3_NAME, please wait"
    aws s3 cp output s3://$AWS_S3_NAME/ --recursive --quiet
    echo "Upload into the bucket: $AWS_S3_NAME, done"
}

# Send Slack message
Slack()
{
    export WEBHOOK_URL="$WEBHOOK_URL"
}

while getopts "h/a/v/b/c/o/u/j/y/r:/p:/s:/w:" option; do
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
      j) # only cli output without json
         CLI_json
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
      s) # send output in aws s3
         AWS_S3_NAME+="$OPTARG"
         s3_aws_profile=true
         ;;
      w) # send report result to slack
         WEBHOOK_URL+="$OPTARG"
         Slack
         ;;
      \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
    esac
done

if [ "$cli_output_csv" = "no" ]; then
    if [ "$cli_output_html" = "yes" ] || [ "$cli_output_json" = "yes" ]; then
        echo "Please disable: Output without CSV (command -u) for the HTML or JSON output"
        exit
    fi
fi

if $show_banner; then
    cat file/logo.txt
fi

JSON()
{
    for file in output/csv/yriser*.csv; do
      # Extract the filename without the extension
      filename=$(basename -- "$file")
      filename="${filename%.*}"
      # Check if the JSON file already exists
      if [ -f "output/json/$filename.json" ]; then
        continue
      fi
      # Execute the jq command on the .csv file and save the result to a .json file
      jq --slurp --raw-input --raw-output \
        'split("\n") | .[0:] | map(split(",")) |
        map({"ASSESSMENT_START_TIME": .[0],
             "TAG_KEY": .[1],
             "TAG_VALUE": .[2],
             "RESOURCE_ID": .[3],
             "ACCOUNT_ID": .[4],
             "REGION": .[5]}) | map(select(.ASSESSMENT_START_TIME != null))' \
        "$file" > "output/json/$filename.json"
    done

    for file in output/csv/mul*.csv; do
      # Extract the filename without the extension
      filename=$(basename -- "$file")
      filename="${filename%.*}"
      # Check if the JSON file already exists
      if [ -f "output/json/$filename.json" ]; then
        continue
      fi
      # Execute the jq command on the .csv file and save the result to a .json file
      jq --slurp --raw-input --raw-output \
        'split("\n") | .[0:] | map(split(",")) |
        map({"TAG_VALUE": .[0],
             "NUMBER": .[1]}) | map(select(.TAG_VALUE != null))' \
        "$file" > "output/json/$filename.json"
    done
}

# Create output folder for first time scan with redirected stout
mkdir -p output
mkdir -p output/txt
mkdir -p output/csv
mkdir -p output/html
mkdir -p output/json

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

if $s3_aws_profile; then
    S3
fi

if [ "$cli_output_json" = "yes" ]; then
    JSON
fi