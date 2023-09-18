#Requires -PSEdition Core
#Requires -Version 7.3

Remove-Item "$HOME\.scripts" -Recurse -Force -ErrorAction Ignore
Copy-Item scripts "$HOME\.scripts" -Recurse -Force
