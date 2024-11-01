#!/bin/bash

# Check if log file path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 path_to_log_file"
    exit 1
fi

LOG_FILE="$1"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found!"
    exit 1
fi

# Count total errors
ERROR_COUNT=$(grep -cE "ERROR|Failed" "$LOG_FILE")
echo "Total Error Count: $ERROR_COUNT"

# Locate critical events and store with line numbers
CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE")
echo "Critical Events:"
echo "$CRITICAL_EVENTS"

# Find top 5 most common error messages
TOP_ERRORS=$(grep -E "ERROR|Failed" "$LOG_FILE" | sort | uniq -c | sort -nr | head -5)
echo "Top 5 Error Messages:"
echo "$TOP_ERRORS"

# Create the report file
REPORT_FILE="log_report_$(date +%F).txt"

{
    echo "Log Analysis Report"
    echo "Date of Analysis: $(date)"
    echo "Log File Name: $LOG_FILE"
    echo "Total Lines Processed: $(wc -l < "$LOG_FILE")"
    echo "Total Error Count: $ERROR_COUNT"
    echo ""
    echo "Top 5 Error Messages:"
    echo "$TOP_ERRORS"
    echo ""
    echo "List of Critical Events (Line Numbers):"
    echo "$CRITICAL_EVENTS"
} > "$REPORT_FILE"

echo "Report generated: $REPORT_FILE"

# Archive log file after processing
ARCHIVE_DIR="processed_logs"
mkdir -p "$ARCHIVE_DIR"
mv "$LOG_FILE" "$ARCHIVE_DIR"
echo "Log file archived in $ARCHIVE_DIR"

