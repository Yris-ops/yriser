#!/bin/bash
# Authored by Antoine CICHOWICZ
# Copyright: Apache License 2.0
# Yriser - https://github.com/yris-ops/yriser

contains_element() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

SOURCE_FILE=${1}
OUTPUT_FILE=${2}
OUTPUT_CSV=${3}
ACCOUNT=${4}
REGION=${5}

# Report VAR
YRIS_SCORE=0
TOTAL_RESOURCES=0
NUMBER_OF_ERRORS=0
NUMBER_OF_OK=1
TAG_CORRECT=0
TAG_CPT=1

## Error VAR int

line_number=1
number_RESOURCETAGMAPPINGLIST=0
number_RESOURCETAGMAPPINGLIST_without_tag=0

# Error Tags Value

# Comparative STRING

substr1=RESOURCETAGMAPPINGLIST
substr2=TAGS

# Progress bar VAR

file_line=$(wc -l < "$SOURCE_FILE")
percent=0

# Lists for variables

# Variable for capturing errors in RESOURCE TAG MAPPING LIST
RESOURCETAGMAPPINGLIST_errors_without_tag=""

# Get the current date and time in the desired format
ASSESSMENT_START_TIME=$(date +%Y-%m-%dT%H:%M:%SZ)
start=$(date +%s)

while read -r l; do
  RESOURCETAGMAPPINGLIST=$(echo "$l" | sed -n '/RESOURCETAGMAPPINGLIST/p' | sed 's/^[^:]*://' | sed 's/^[^:]*://' | sed 's/^[^:]*://' | sed 's/^[^:]*://' | sed 's/^[^:]*://')
  if [ -n "$RESOURCETAGMAPPINGLIST" ]; then
    RESOURCETAGMAPPINGLIST_type=""
    RESOURCETAGMAPPINGLIST_name=""
    RESOURCETAGMAPPINGLIST_id=""

    RESOURCETAGMAPPINGLIST_type=$(echo "$RESOURCETAGMAPPINGLIST" | sed 's/\/.*//')
    RESOURCETAGMAPPINGLIST_name=$(echo "$RESOURCETAGMAPPINGLIST" | sed -e 's/.*\/\(.*\)\/.*/\1/')
    RESOURCETAGMAPPINGLIST_name2=$(echo "$RESOURCETAGMAPPINGLIST_name" | sed 's/.*\///g')
    RESOURCETAGMAPPINGLIST_id=$(echo "$RESOURCETAGMAPPINGLIST" | sed 's/.*\///g')

    if [ "$RESOURCETAGMAPPINGLIST_type" = "$RESOURCETAGMAPPINGLIST_name" ]; then
      echo "$line_number -> $RESOURCETAGMAPPINGLIST_type" >> "output/txt/$OUTPUT_FILE.txt"
      TOTAL_RESOURCES=$((TOTAL_RESOURCES + 1))
    elif [ "$RESOURCETAGMAPPINGLIST_name2" = "$RESOURCETAGMAPPINGLIST_id" ] 2>/dev/null; then
      echo "$line_number -> $RESOURCETAGMAPPINGLIST_type $RESOURCETAGMAPPINGLIST_name2 " >> "output/txt/$OUTPUT_FILE.txt"
      TOTAL_RESOURCES=$((TOTAL_RESOURCES + 1))
    else
      echo "$line_number -> $RESOURCETAGMAPPINGLIST_type $RESOURCETAGMAPPINGLIST_name $RESOURCETAGMAPPINGLIST_id" >> "output/txt/$OUTPUT_FILE.txt"
      TOTAL_RESOURCES=$((TOTAL_RESOURCES + 1))
    fi
  fi

  # Check if RESOURCE has one tag

  TAG_CPT=$((TAG_CPT + 1))
  line_number_tag=$((line_number + 1))
  if [[ $l == *"$substr1"* ]]; then
    number_RESOURCETAGMAPPINGLIST=$((number_RESOURCETAGMAPPINGLIST + 1))
    CHECK_TAG_EXIST=$(sed -n "$line_number_tag"p "$SOURCE_FILE")
    if [[ $CHECK_TAG_EXIST == *"$substr2"* ]]; then
      ll=$line_number_tag
      CHECK_TAG_EXIST_2=$substr2
      while [[ $CHECK_TAG_EXIST_2 == *"$substr2"* ]]; do
        CHECK_TAG_EXIST_2=$(sed -n "$ll"p "$SOURCE_FILE")
        ll=$((ll + 1))
        FIND_KEY=$(echo "$CHECK_TAG_EXIST_2" | awk '{print $2;}')
        FIND_VALUE=$(echo "$CHECK_TAG_EXIST_2" | awk '{print $3;}')

        # Check if Key exists
            *)
              echo "OK    | TAG  $FIND_KEY $FIND_VALUE" >> "output/txt/$OUTPUT_FILE.txt"
              ;;
          esac
        fi
      done
    else
      RESOURCETAGMAPPINGLIST_errors_without_tag+="$RESOURCETAGMAPPINGLIST "
      number_RESOURCETAGMAPPINGLIST_without_tag=$((number_RESOURCETAGMAPPINGLIST_without_tag + 1))
      echo "    > Warning : $RESOURCETAGMAPPINGLIST_type -> Without tag" >> "output/txt/$OUTPUT_FILE.txt"
      echo "" >> "output/txt/$OUTPUT_FILE.txt"
    fi
  fi

  progress_bar=$((line_number * 100 / file_line))
  time="$(($(date +%s) - $start))"
  hours=$((time / 3600))
  minutes=$(( (time % 3600) / 60 ))
  seconds=$((time % 60))
  echo -en "\r-> Scan in progress! $ACCOUNT [$REGION] analysis: \033[33m[$progress_bar%]\033[0m in $hours:$minutes:$seconds"
  line_number=$((line_number + 1))
done < "$SOURCE_FILE"

ALL_TAG=$((ROCK_TAG + FLEX_TAG))
TAG_CPT=$((TAG_CPT - TOTAL_RESOURCES))
TAG_CORRECT_PER=$(echo "scale=2; $NUMBER_OF_OK / $TAG_CPT * 100" | bc)
NUMBER_OF_ERRORS_PER=$(echo "scale=2; $NUMBER_OF_ERRORS / $TAG_CPT * 100" | bc)
number_RESOURCETAGMAPPINGLIST_without_tag_PER=$(echo "scale=2; $number_RESOURCETAGMAPPINGLIST_without_tag / $TAG_CPT * 100" | bc)
NUMBER_OF_ERRORS_CAL=$((TAG_CPT - NUMBER_OF_OK - NUMBER_OF_ERRORS - number_RESOURCETAGMAPPINGLIST_without_tag))
NUMBER_OF_ERRORS_CAL_PER=$(echo "scale=2; $NUMBER_OF_ERRORS_CAL / $TAG_CPT * 100" | bc)
TOTAL_ERROR=$((NUMBER_OF_ERRORS_CAL + NUMBER_OF_ERRORS + number_RESOURCETAGMAPPINGLIST_without_tag))
YRIS_SCORE=$(echo "scale=2; $TOTAL_ERROR / $TAG_CPT * 100" | bc)
YRIS_SCORE=$(echo "scale=2; 100 - $YRIS_SCORE" | bc)

echo -en "\r\r-> Scan completed! $ACCOUNT [$REGION] analysis: $TAG_CPT/$TAG_CPT \033[33m[100%]\033[0m in $hours:$minutes:$seconds"
echo ""

## Output CLI

## Generate CSV output

## Resources without tag
IFS=' ' read -ra ASSOCIATE_WITH_ERRORS <<< "$RESOURCETAGMAPPINGLIST_errors_without_tag"
for error in "${ASSOCIATE_WITH_ERRORS[@]}"; do
  echo "$ASSESSMENT_START_TIME,without tag,none,$error,$ACCOUNT,$REGION" >> "output/csv/$OUTPUT_CSV"
done

## 2Generate CSV output


## 3.2 Generate CSV Error Tag value

OUTPUT_FILE_TAG_VALUE="output/txt/$OUTPUT_FILE.txt"
OUTPUT_FILE_TAG_VALUE_CSV="output/csv/$OUTPUT_CSV"

TEMP_FILE_TAG_VALUE=$(mktemp)

while IFS= read -r ligne_tag_value
do
  if [[ $ligne_tag_value == ERROR* ]]; then
    last_word=$(echo $ligne_tag_value | awk '{print $NF}')    
    list_error_tag_value+=("$last_word")
  fi
done < "$OUTPUT_FILE_TAG_VALUE"


if [[ ${#list_error_tag_value[@]} -gt 0 ]]; then
  for erreur in "${list_error_tag_value[@]}"
  do
    sed "s/,/,$erreur,/" "$OUTPUT_FILE_TAG_VALUE_CSV" > "$TEMP_FILE_TAG_VALUE"
  done
fi

if [[ ${#list_error_tag_value[@]} -gt 0 ]]; then
  for ((i=0; i<${#list_error_tag_value[@]}; i++))
  do
    erreur="${list_error_tag_value[$i]}"
    ligne_tag_value_numero=$((i+1))
    sed "${ligne_tag_value_numero}s/,/,$erreur,/2" "$OUTPUT_FILE_TAG_VALUE_CSV" > "$TEMP_FILE_TAG_VALUE"
    mv "$TEMP_FILE_TAG_VALUE" "$OUTPUT_FILE_TAG_VALUE_CSV"
  done
fi

## 3.1 Generate CSV clear multi

file="output/csv/mul-$OUTPUT_CSV"
data=$(cat "$file")
tmp_file_mul=$(mktemp)

count_occurrences() {
    local element=$1
    local list=("${@:2}")
    local count=0

    for item in "${list[@]}"; do
        if [[ "$item" == "$element" ]]; then
            ((count++))
        fi
    done

    echo "$count"
}

new_data=""
current_section=""
current_list=()

while IFS= read -r line; do
    if [[ "$line" == *":" ]]; then
        if [[ -n "$current_section" ]]; then
            unique_elements=($(printf "%s\n" "${current_list[@]}" | sort -u))
            for element in "${unique_elements[@]}"; do
                count=$(count_occurrences "$element" "${current_list[@]}")
                new_data+="\n$element,$count"
            done
            new_data+="\n"
        fi
        current_section="$line"
        current_list=()
        new_data+="$line\n"
    elif [[ -n "$line" ]]; then
        current_list+=("$line")
    fi
done <<< "$data"

unique_elements=($(printf "%s\n" "${current_list[@]}" | sort -u))
for element in "${unique_elements[@]}"; do
    count=$(count_occurrences "$element" "${current_list[@]}")
    new_data+="\n$element,$count"
done
new_data+="\n"
echo -e "$new_data" > "$tmp_file_mul"
grep . "$tmp_file_mul" > "$file"

if [ "$cli_output_csv" = "no" ]; then
  find output/csv -type f -name "*$PATH_DATE*" -exec rm {} +
fi

# Generate HTML report
if [ "$cli_output_html" = "yes" ]; then
  echo "<html lang="en">
  <head>
    <title>Yriser - Report Tag Assessments in AWS</title>
    <meta name="keywords" content="Yriser"/>
    <meta name="description" content ="Yriser is an Open Source FinOps tool to perform AWS tagging best practices, tagging strategy, continuous adjustments in cloud optimization."/>
    <meta name="author" content="Antoine CICHOWICZ"/>
    <meta name="copyright" content="Copyright © 2023 Antoine CICHOWICZ - Yriser - Apache License 2.0" />

    <style>
      body {
        font-family: Arial, sans-serif;
        margin: auto;
        background-color: #f7f7f7;
        color: #444;
      }

      .top {
        background-color: #343a40!important;
      }

      h1 {
        color: #FFF;
        font-size: 24px;
        margin-left: 20px;
        padding: 14px 16px;
      }

      h2 {
        font-size: 20px;
      }

      h3 {
        font-size: 20px;
        margin-bottom: 10px;
      }

      table {
        border-collapse: collapse;
        width: 98%;
        background-color: #fff;
        border: 1px solid #ddd;
        margin-left: 10px;
      }

      th, td {
        text-align: left;
        padding: 8px;
        border-bottom: 1px solid #ddd;
      }

      th {
        background-color: #f2f2f2;
        font-weight: bold;
      }

      tr:hover {
        background-color: #f5f5f5;
      }

      span.a {
        display: flex;
        padding: 10px;
      }

      #assessement_table_css { margin-left: 10px; }
    </style>
    <script>
      function searchTable() {
        var input = document.getElementById(\"searchInput\").value.toLowerCase();
        
        var table = document.getElementById(\"assessement_table\");
        var rows = table.getElementsByTagName(\"tr\");
        
        for (var i = 0; i < rows.length; i++) {
          var rowData = rows[i].getElementsByTagName(\"td\");
          var found = false;
          
          for (var j = 0; j < rowData.length; j++) {
            var cellData = rowData[j];
            
            if (cellData.innerHTML.toLowerCase().indexOf(input) > -1) {
              found = true;
              break;
            }
          }
          
          if (found) {
            rows[i].style.display = \"\";
          } else {
            rows[i].style.display = \"none\";
          }
        }
      }
    </script>
  </head>
  <body>
    <div class="top">
      <h1>Yriser - AWS Report Tag Assessments </h1>
    </div>
    <span class="a">
      <table>
        <caption><h2>Report Information:</h2></caption>
        <tr>
          <th>Version:</th>
          <td>$VERSION</td>
        </tr>
        <tr>
          <th>Parameters used:</th>
          <td>-$SOURCE_FILE -$ACCOUNT -$REGION</td>
        </tr>
        <tr>
          <th>Date:</th>
          <td>$ASSESSMENT_START_TIME</td>
        </tr>
        <tr>
          <th>Ressources scanning</th>
          <td>$TOTAL_RESOURCES<td>
        </tr>
        <tr>
          <th>Tagging Rules:</th>
          <td>$ALL_TAG</td>
        </tr>
        <tr>
          <th>Unique tag:</th>
          <td>$ROCK_TAG</td>
        </tr>
        <tr>
          <th>Multiple tag:</th>
          <td>$FLEX_TAG</td>
        </tr>
      </table>
      <table>
        <caption><h2><h2>Assessment Summary:</h2></caption>
        <tr>
          <th>AWS Account:</th>
          <td>$ACCOUNT</td>
        </tr>
        <tr>
          <th>API Region:</th>
          <td>$REGION</td>
        </tr>
        <tr>
          <th>UserID:</th>
          <td>$AWSUSERID</td>
        </tr>
        <tr>
          <th>Caller Identity ARN:</th>
          <td>$AWSARN</td>
        </tr>
        <caption align="BOTTOM"><img src=https://github.com/Yris-ops/yriser/blob/main/file/yriser-logo.png?raw=true alt=Yriser Logo><caption>
      </table>

      <table>
        <caption><h2><h2>Scoring Information:</h2></caption>
        <tr>
          <th>Yris score:</th>
          <td>$YRIS_SCORE%</td>
        </tr>
        <tr>
          <th>Total Tags Scanning:</th>
          <td>$TAG_CPT</td>
        </tr>
        <tr>
          <th>Correctly tagged</th>
          <td>$NUMBER_OF_OK</td>
        </tr>
        <tr>
          <th>Number of errors:</th>
          <td>$NUMBER_OF_ERRORS</td>
        </tr>
        <tr>
          <th>Ressources with other tags:</th>
          <td>$NUMBER_OF_ERRORS_CAL</td>
        <tr> 
        <tr>
          <th>Resources without tag:</th>
          <td>$number_RESOURCETAGMAPPINGLIST_without_tag</td>
        <tr>  
      </table>
    </span>

    <center><h3>Tag Assessment Details:</h3></center>
    <span id="assessement_table_css">Search: </span><input type=\"text\" id=\"searchInput\" placeholder=\"...\" onkeyup=\"searchTable()\">
    <br><br>
    <table id="assessement_table">
      <tr>
        <th>ASSESSMENT START TIME</th>
        <th>TAG KEY</th>
        <th>TAG VALUE</th>
        <th>RESOURCE ID</th>
        <th>ACCOUNT ID</th>
        <th>REGION</th>
      </tr>" > "output/html/$OUTPUT_FILE.html"
      
  while IFS= read -r line; do
    echo -e "    <tr>
        <td>${line//,/</td>\n      <td>}</td>
      </tr>" >> "output/html/$OUTPUT_FILE.html"
  done < "output/csv/$OUTPUT_CSV"

  echo "  </table>
    <table>
      <caption><h2>Multiple Tag:</h2></caption>
      <tr>
        <th>TAG VALUE</th>
        <th>NUMBER</th>
      </tr>" >> "output/html/$OUTPUT_FILE.html"

  while IFS= read -r line; do
    echo "    <tr>
        <td>${line//,/</td><td>}</td>
      </tr>" >> "output/html/$OUTPUT_FILE.html"
  done < "output/csv/mul-$OUTPUT_CSV"

  echo "  </table>
  </body>
  </html>" >> "output/html/$OUTPUT_FILE.html"

  echo "Detailed results are in:"
  echo "  - HTML: $(pwd)/output/html/$OUTPUT_FILE.html"
fi

if [ "$cli_output_csv" = "yes" ]; then
echo "  - CSV: $(pwd)/output/csv/$OUTPUT_CSV"
echo "  - CSV: $(pwd)/output/csv/mul-$OUTPUT_CSV"
fi

rm -rf output/.txt 2> /dev/null