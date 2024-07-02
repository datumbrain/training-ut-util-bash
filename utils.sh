#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 --operation merge --input-path <dir> --output-path <dir> --format csv"
    exit 1
}

# Initialize variables
operation=""
input_path=""
output_path=""
format="jsonl"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --operation)
            operation="$2"
            shift 2  # Move past the argument and its value
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
            shift 2
            ;;
        *)
            echo "Invalid option: $1"
            usage
            ;;
    esac
done

# Check if the operation is 'merge'
if [[ "$operation" != "merge" ]]; then
	echo "Invalid operation: $operation"
    	usage
fi

# Check if the input path is a valid directory
if [[ ! -d "$input_path" ]]; then
	echo "Input directory '$input_path' does not exist."
	usage
fi

# Create output directory if it doesn't exist
if [[ ! -d "$output_path" ]]; then
	mkdir -p "$output_path" || { echo "Failed to create output directory '$output_path'"; exit 1; }
fi

# Set the output file name based on the desired format
output_file="$output_path/merged_data.$format"

merged_data=""

# If .jsonl extension file detected, merge their contents into a single file
for file in "$input_path"/*.jsonl; do
	if [[ -f "$file" ]]; then
        	merged_data+=$(cat "$file")$'\n'
    	fi
done

# Check if any data was read
if [[ -z "$merged_data" ]]; then
	echo "No JSONL files found in the input directory."
	exit 0
fi

# Convert merged JSONL data to CSV format if specified
if [[ "$format" == "csv" ]]; then
    # Extract headers and convert the JSONL data to CSV format using jq
	echo "$merged_data" | jq -r -s '
        (.[0] | keys_unsorted) as $keys |  # Extract keys from the first JSON object and use them as headers
        $keys,
        map([.[ $keys[] ]])[] |  # Convert each JSON object to a CSV row based on the headers
        @csv
    ' > "$output_file" || { echo "Failed to save CSV file"; exit 1; }
else
    # If the format is not CSV, just save the merged JSONL data as it is
	echo "$merged_data" > "$output_file" || { echo "Failed to save JSONL file"; exit 1; }
fi

# Verify the output file
if [[ -f "$output_file" ]]; then
	echo "Merged data saved to: $output_file"
else
	echo "Failed to save merged data to: $output_file"
fi

