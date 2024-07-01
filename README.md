# Utility

This repository contains a bash script that performs file merging operations. The script merges all JSONL files in a specified directory into a single JSONL file and stores it in an output directory. Additionally, if the `--format csv` flag is used, the output is a CSV file.

## Task Description

**Objective:** Create a bash script named `util.sh` that performs file merging operations. The script should merge all JSONL files in a specified directory into a single JSONL file and store it in an output directory. Additionally, if the `--format csv` flag is used, the output should be a CSV file.

## Requirements

1. **Script Arguments:**

   - `--operation merge`: Specifies the operation to be performed.
   - `--input-path ./<any_path>`: Path to the directory containing JSONL files to be merged.
   - `--output-path ./<any_path>`: Path to the directory where the merged file will be stored.
   - `--format csv`: (Optional) If provided, the output should be a CSV file instead of a JSONL file.

2. **Functionality:**
   - Read all JSONL files from the input directory.
   - Merge the content of all JSONL files into a single JSONL file.
   - If the `--format csv` flag is detected, convert the merged JSONL content to CSV format.
   - Save the merged file (in JSONL or CSV format) to the specified output directory.

## Example Commands

1. Merge JSONL files into a single JSONL file:

   ```bash
   ./util.sh --operation merge --input-path ./data/jsonl_files/ --output-path ./output_data
   ```

2. Merge JSONL files and output as a CSV file:

   ```bash
   ./util.sh --operation merge --input-path ./data/jsonl_files/ --output-path ./output_data --format csv
   ```
