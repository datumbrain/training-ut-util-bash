#!/bin/bash

usage() {
       echo "Usage: $0 -o merge -i <dir> -p <dir> -f csv"
       exit 1
}

operation=""
input_path=""
output_path=""
format="json"

while getopts ":o:i:p:f:" opt; do

       case $opt in
               o) operation="$OPTARG" ;;
               i) input_path="$OPTARG" ;;
               p) output_path="$OPTARG" ;;
               f) format="$OPTARG" ;;
               \?) echo "Invalid option:"; usage ;;
        esac
done

if [[ "$operation" != "merge" ]]; then
	echo "Only merge operation is possible"
	usage
fi

if [[ ! -d "$input_path" ]]; then
       echo "Input directory '$input_path' does not exist."
       usage       
fi

output_file="$output_path/merged_data.$format"

merged_data=""
for file in "$input_path"/*.json; do
       if [[ -f "$file" ]]; then
               merged_data+=$(cat "$file")$'\n'
fi
done

if [[ -z "$merged_data" ]]; then
       echo " No JSONL files found in the input directory."
       exit 0
fi

if [[ "$format" == "csv" ]]; then
	echo "$merged_data" | jq -r '
  map(if type == "array" then .[] else . end) |
  (.[0] | to_entries | map(.key)) as $keys |
  $keys, map(. as $value | $keys[] as $key | [$key, $value[$key]])[] | @csv
  ' > "$output_path/output.csv"
	output_file="$output_path/output.csv"
else
	echo "$merged_data" > "$output_file"
fi

if [[ ! -d "$output_path" ]]; then
	echo "Output directory '$output_path' does not exist."
	usage
fi

echo "Merged data saved to: $output_file"
