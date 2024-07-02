#!/bin/bash

usage() {
    echo "Usage: $0 --operation merge --input-path <dir> --output-path <dir> --format csv"
    exit 1
}

operation=""
input_path=""
output_path=""
format="jsonl"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --operation)
            operation="$2"
            shift 2 
            ;;
        --input-path)
            input_path="$2"
            shift 2
            ;;
        --output-path)
            output_path="$2"
            shift 2
            ;;
        --format)
            format="$2"
            shift 2 #to prevent infinite loop 
            ;;
        *)
            echo "Invalid option: $1"
            usage
            ;;
    esac
done

if [[ "$operation" != "merge" ]]; then
	echo "Invalid operation: $operation"
    	usage
fi

if [[ ! -d "$input_path" ]]; then
	echo "Input directory '$input_path' does not exist."
	usage
fi

if [[ ! -d "$output_path" ]]; then
	mkdir -p "$output_path"
fi

output_file="$output_path/merged_data.$format"

merged_data=""

# If .jsonl extension file detected, merge their contents into a single file
for file in "$input_path"/*.jsonl; do
	if [[ -f "$file" ]]; then
		merged_data+=$(cat "$file")$'\n'
    	fi
done

if [[ -z "$merged_data" ]]; then
	echo "No JSONL files found in the input directory."
        exit 0
fi

if [[ "$format" == "csv" ]]; then
	#extract headers and convert the jsonl data to CSV format.
        headers=$(echo "$merged_data" | jq -s 'map(keys) | add | unique | join(",")')
        echo "$headers" > "$output_file"
	
	#convert the jsonl objects to CSV rows and appends them to the output file.
	echo "$merged_data" | jq -r -s '
        map([.[]])
        | (.[0] | keys_unsorted) as $keys
        | $keys, map([.[ $keys[] ]])[]
        | @csv
    ' >> "$output_file"
else
	echo "$merged_data" > "$output_file"
fi

echo "Merged data saved to: $output_file"

