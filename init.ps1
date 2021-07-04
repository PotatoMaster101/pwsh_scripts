########################################################################################################################
# Sets script location.
########################################################################################################################

#Requires -PSEdition Core
#Requires -Version 7.1

Remove-Item "$HOME\.scripts" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item scripts "$HOME\.scripts" -Recurse -Force
