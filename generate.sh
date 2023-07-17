#!/bin/bash
# Authored by Antoine CICHOWICZ
# Copyright: Apache License 2.0
# Yriser - https://github.com/yris-ops/yriser

report_file=${1}
config_file="config.txt"
tmp_file=$(mktemp)

line_number_key=$(grep -n "## TAG KEY" "$config_file" | cut -d':' -f1)
line_number_value=$(grep -n "## TAG VALUE" "$config_file" | cut -d':' -f1)
line_number_key_add=$((line_number_key + 1))
line_number_value_add=$((line_number_value + 1))
line_number_value_end=$((line_number_value - 1))
line_end=$(wc -l config.txt | grep -o "[0-9]\+")

line_number_report=$(grep -n "# Report VAR" "$report_file" | cut -d':' -f1)
line_number=$(grep -n "# Error Tags Value" "$report_file" | cut -d':' -f1)
line_number_list=$(grep -n "# Lists for variables" "$report_file" | cut -d':' -f1)
line_number_error=$(grep -n "# Variable for capturing errors in RESOURCE TAG MAPPING LIST" "$report_file" | cut -d':' -f1)
line_number_key_2=$(grep -n "        # Check if Key exists" "$report_file" | cut -d':' -f1)
line_number_cli=$(grep -n "## Output CLI" "$report_file" | cut -d':' -f1)
line_number_generate=$(grep -n "## Generate CSV output" "$report_file" | cut -d':' -f1)
line_number_generate_2=$(grep -n "## 2Generate CSV output" "$report_file" | cut -d':' -f1)

total_tag=$((line_number_value - line_number_key - 1 ))
flex_tag=$(grep -o "()" $config_file | wc -l | grep -o "[0-9]\+")
rock_tag=$((total_tag - flex_tag))

lines=1
lines_value=1

while IFS= read -r line; do
  if [ "$lines" -ge "$line_number_key_add" ] && [ "$lines" -le "$line_number_value_end" ]; then
    tagss+=("$line")
    line=$(echo "$line" | sed 's/:/_/g')
    line=$(echo "$line" | sed 's/-/_/g')
    tags+=("$line")
  fi
  lines=$((lines + 1))
done < "$config_file"

while IFS= read -r line_value; do
  if [ "$lines_value" -ge "$line_number_value_add" ] && [ "$lines_value" -le "$line_end" ]; then
    list+=("$line_value")
  fi
  lines_value=$((lines_value + 1))
done < "$config_file"

## Report file >> 

head -n "$line_number_generate_2" "$report_file" > "$tmp_file"
for i in "${!tags[@]}"
do
  if [ "${list[i]}" = "()" ]; then
    echo "echo \"${tags[i]}_list:\" >> \"output/csv/mul-\$OUTPUT_CSV\"" >> "$tmp_file"
    echo "for item in \"\${${tags[i]}_list[@]}\"; do" >> "$tmp_file"
    echo "    echo \"\$item\" >> \"output/csv/mul-\$OUTPUT_CSV\"" >> "$tmp_file"
    echo "done" >> "$tmp_file"
  fi
done
tail -n +$((line_number_generate_2+1)) "$report_file" >> "$tmp_file"
mv "$tmp_file" "$report_file"

head -n "$line_number_generate" "$report_file" > "$tmp_file"
for i in "${!tags[@]}"
do
  if [ "${list[i]}" != "()" ]; then
    echo "# ${tags[i]}_error" >> "$tmp_file"
    echo "IFS=' ' read -ra ${tags[i]}_ERRORS <<< \"\$RESOURCETAGMAPPINGLIST_errors_${tags[i]}\"" >> "$tmp_file"
    echo "for error in \"\${${tags[i]}_ERRORS[@]}\"; do" >> "$tmp_file"
    echo "  echo \"\$ASSESSMENT_START_TIME,${tagss[i]},\$error,\$ACCOUNT,\$REGION\" >> \"output/csv/\$OUTPUT_CSV\"" >> "$tmp_file"
    echo "done" >> "$tmp_file"
  fi
done
tail -n +$((line_number_generate+1)) "$report_file" >> "$tmp_file"
mv "$tmp_file" "$report_file"

head -n "$line_number_cli" "$report_file" > "$tmp_file"
echo "echo \"-----------------------\"" >> "$tmp_file"
echo "echo \"-----------------------\"" >> "$tmp_file"
echo "echo \"Tags Value Error Report\"" >> "$tmp_file"
echo "echo \"-----------------------\"" >> "$tmp_file"
echo "echo \"-----------------------\"" >> "$tmp_file"
for i in "${!tags[@]}"
do
  if [ "${list[i]}" != "()" ]; then 
  echo "echo \"${tags[i]} -> \$ERROR_TAGS_VALUE_${tags[i]}\"" >> "$tmp_file"
  fi
done
echo "echo \"-----------------------\"" >> "$tmp_file"
echo "echo \"-----------------------\"" >> "$tmp_file"
echo "echo \"List Value Error Report\"" >> "$tmp_file"
echo "echo \"-----------------------\"" >> "$tmp_file"
echo "echo \"-----------------------\"" >> "$tmp_file"
for i in "${!tags[@]}"
do
  if [ "${list[i]}" = "()" ]; then 
  echo "echo \"${tags[i]}:\"" >> "$tmp_file"
  echo "for item in \"\${${tags[i]}_list[@]}\"; do" >> "$tmp_file"
  echo "  echo \"\$item\"" >> "$tmp_file"
  echo "done" >> "$tmp_file"
  echo "echo \"\"" >> "$tmp_file"
  fi
done
echo "echo \"-----------------------\"" >> "$tmp_file"
echo "echo \"-----------------------\"" >> "$tmp_file"
tail -n +$((line_number_cli+1)) "$report_file" >> "$tmp_file"
mv "$tmp_file" "$report_file"

head -n "$line_number_key_2" "$report_file" > "$tmp_file"
echo -ne "        if contains_element \"\$FIND_KEY\" " >> "$tmp_file"
for tag in "${tagss[@]}"
do
  echo -ne "\"$tag\" " >> "$tmp_file"
done
echo "; then" >> "$tmp_file"
echo "          case \"\$FIND_KEY\" in" >> "$tmp_file"
for i in "${!tags[@]}"
do
  if [ "${list[i]}" = "()" ]; then
    echo "            \"${tagss[i]}\")" >> "$tmp_file"
    echo "              ${tags[i]}_list+=(\"\$FIND_VALUE\")" >> "$tmp_file"
    echo "              echo \"OK    | TAG  \$FIND_KEY \$FIND_VALUE\" >> \"output/txt/\$OUTPUT_FILE.txt\"" >> "$tmp_file"
    echo "                NUMBER_OF_OK=\$((NUMBER_OF_OK + 1))" >> "$tmp_file"
    echo "              ;;" >> "$tmp_file"
  else  
    echo "            \"${tagss[i]}\")" >> "$tmp_file"
    echo "              if contains_element \"\$FIND_VALUE\" \"\${"${tags[i]}"_list[@]}\"; then" >> "$tmp_file"
    echo "                echo \"OK    | TAG  \$FIND_KEY \$FIND_VALUE\" >> \"output/txt/\$OUTPUT_FILE.txt\"" >> "$tmp_file"
    echo "                NUMBER_OF_OK=\$((NUMBER_OF_OK + 1))" >> "$tmp_file"
    echo "              else" >> "$tmp_file"
    echo "                echo \"ERROR | TAG  \$FIND_KEY \$FIND_VALUE\" >> \"output/txt/\$OUTPUT_FILE.txt\"" >> "$tmp_file"
    echo "                ERROR_TAGS_VALUE_${tags[i]}=\$((ERROR_TAGS_VALUE_${tags[i]} + 1))" >> "$tmp_file"
    echo "                RESOURCETAGMAPPINGLIST_errors_${tags[i]}+=\"\$RESOURCETAGMAPPINGLIST \"" >> "$tmp_file"
    echo "                NUMBER_OF_ERRORS=\$((NUMBER_OF_ERRORS + 1))" >> "$tmp_file"
    echo "              fi" >> "$tmp_file"
    echo "              ;;" >> "$tmp_file"
  fi
done
tail -n +$((line_number_key_2+1)) "$report_file" >> "$tmp_file"
mv "$tmp_file" "$report_file"

head -n "$line_number_error" "$report_file" > "$tmp_file"
for tag in "${tags[@]}"
do
  echo "RESOURCETAGMAPPINGLIST_errors_$tag=\"\"" >> "$tmp_file"
done
tail -n +$((line_number_error+1)) "$report_file" >> "$tmp_file"
mv "$tmp_file" "$report_file"

length=${#list[@]}
head -n "$line_number_list" "$report_file" > "$tmp_file"
for ((i=0; i<length; i++))
  do
    echo "${tags[i]}_list=${list[i]}" >> "$tmp_file"
  done
tail -n +$((line_number_list+1)) "$report_file" >> "$tmp_file"
mv "$tmp_file" "$report_file"

head -n "$line_number" "$report_file" > "$tmp_file"
for tag in "${tags[@]}"
do
  echo "ERROR_TAGS_VALUE_$tag=0" >> "$tmp_file"
done
tail -n +$((line_number+1)) "$report_file" >> "$tmp_file"
mv "$tmp_file" "$report_file"

head -n "$line_number_report" "$report_file" > "$tmp_file"
echo "ROCK_TAG=$rock_tag" >> "$tmp_file"
echo "FLEX_TAG=$flex_tag" >> "$tmp_file"
tail -n +$((line_number_report+1)) "$report_file" >> "$tmp_file"
mv "$tmp_file" "$report_file"