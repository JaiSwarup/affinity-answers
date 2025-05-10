#!/bin/bash

# URL to fetch NAV data
URL="https://www.amfiindia.com/spages/NAVAll.txt"

# Temporary file
TMP_FILE="NAVAll.txt"
JSON_FILE="nav_data.json"

# Download the file
curl -s "$URL" -o "$TMP_FILE"

# Start JSON array
echo "[" > "$JSON_FILE"

# Parse lines and convert to JSON
awk -F ';' '
BEGIN { first = 1 }
/^[0-9]+;/ {
    if (!first) {
        print "," >> "'"$JSON_FILE"'"
    }
    first = 0
    gsub(/"/, "\\\"", $4)
    printf "{ \"Scheme Code\": \"%s\", \"ISIN Div Payout\": \"%s\", \"ISIN Div Reinvestment\": \"%s\", \"Scheme Name\": \"%s\", \"Net Asset Value\": \"%s\", \"Date\": \"%s\" }", $1, $2, $3, $4, $5, $6 >> "'"$JSON_FILE"'"
}
END {
    print "" >> "'"$JSON_FILE"'"
}
' "$TMP_FILE"

# End JSON array
echo "]" >> "$JSON_FILE"

echo "Saved to $JSON_FILE"
