#  Associative arrays are created using declare -A name.

declare -A stock
stock[APPL]=Apple
stock[ORCL]=Oracle
stock[CRM]="Salesforce"

echo ${stock[$1]} 
