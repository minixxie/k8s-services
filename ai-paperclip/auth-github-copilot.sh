#!/bin/bash

echo "### Before github authentication: ###"
../scripts/exec "opencode models"

../scripts/exec "opencode auth login --provider github-copilot"

echo "### After github authentication: ###"
../scripts/exec "opencode models"
