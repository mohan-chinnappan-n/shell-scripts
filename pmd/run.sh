# Running PMD report on the classes folder

## New HTML Report
# run-pmd.sh pmd -R ~/.pmd/apex_ruleset.xml -d . -f xslt -property  xsltFilename=/Users/mchinnappan/xslts/html-report-v2.xslt > /tmp/pmdout.html; open /tmp/pmdout.html
run-pmd.sh pmd -R ~/.pmd/apex_ruleset.xml -d . -f xslt -property  xsltFilename=html-report-v2.xslt > /tmp/pmdout.html; open /tmp/pmdout.html

## CSV Datatable
run-pmd.sh pmd -R ~/.pmd/apex_ruleset.xml -d . -f csv > /tmp/pmdout.csv; pbcopy < /tmp/pmdout.csv; open "https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=csv"

