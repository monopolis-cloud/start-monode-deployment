#!/bin/ash -xe

get_from_event() {
  jq -r "$1" "${GITHUB_EVENT_PATH}"
}

MONOPOLIS_URL="https://github-api.monopolis.cloud/deploy/start/$(get_from_event '.repository.full_name')/$(get_from_event '.inputs.deployment_id')"

curl --fail \
    -X POST "${MONOPOLIS_URL}" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}"

echo ::set-output name=environment_map::$(get_from_event '.deployment.ref')
