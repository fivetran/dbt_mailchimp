#!/bin/bash

set -euo pipefail

apt-get update
apt-get install libsasl2-dev

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip setuptools
pip install -r integration_tests/requirements.txt
mkdir -p ~/.dbt
cp integration_tests/ci/sample.profiles.yml ~/.dbt/profiles.yml

db=$1
echo `pwd`
cd integration_tests
dbt deps
dbt seed --target "$db" --full-refresh
dbt source freshness --target "$db" || echo "...Only verifying freshness runs…"
dbt run --target "$db" --full-refresh
dbt test --target "$db"
dbt run --vars '{mailchimp_using_automations: false, mailchimp_using_segments: false, mailchimp_using_unsubscribes: false}' --target "$db" --full-refresh
dbt test --target "$db"

dbt run-operation fivetran_utils.drop_schemas_automation --target "$db"
