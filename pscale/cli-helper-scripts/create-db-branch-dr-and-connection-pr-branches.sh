#!/bin/bash

. use-pscale-docker-image.sh
. wait-for-branch-readiness.sh

. authenticate-ps.sh

BRANCH_NAME="$1"
DDL_STATEMENTS="$2" 

. set-db-and-org-and-branch-name.sh

. ps-create-helper-functions-pr-branches.sh
create-db-branch "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "recreate"
create-schema-change "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "$DDL_STATEMENTS"
create-deploy-request "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME"


. create-branch-connection-string-pr-branches.sh
create-branch-connection-string "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME" "testcred"
    # if $2 and $3 are set, generate secret output links
    if [ -n "$2" ] && [ -n "$3" ]; then
        for i in `seq 1 $2`; do
            for j in `seq 1 $3`; do
                echo "::set-output name=dbconnection_${i}_${j}::`curl -s -X POST -d "plain&secret=$MY_DB_URL" https://shared-secrets-planetscale.herokuapp.com/`"          
            done
        done
    fi

. dump-and-restore-db-branch.sh "$DB_NAME" "$BRANCH_NAME" "$ORG_NAME"