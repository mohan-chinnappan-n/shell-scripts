# comment out encryptionScheme
#find $1 -type f -name "*meta.xml" -exec sed -i '' 's|<encryptionScheme>xyz</encryptionScheme>|<!-- <encryptionScheme>xyz</encryptionScheme> -->|g' {} \;
find $1 -type f -name "*-meta.xml" -exec sed -i '' 's|<encryptionScheme>.*</encryptionScheme>|<!-- & -->|g' {} \;

