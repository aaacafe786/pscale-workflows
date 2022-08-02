#!/bin/bash
cd $HOME
pscale database dump "$DB_NAME" "main" --org "$ORG_NAME" --output ".pscale/cli-helper-scripts"
pscale database restore-dump  "$DB_NAME" "$BRANCH_NAME" --overwrite-tables --org "$ORG_NAME" --dir ".pscale/cli-helper-scripts/pscale_dump_osc-academic_main"