#!/bin/ash -xe

get_from_event() {
  jq -r "$1" "${GITHUB_EVENT_PATH}"
}

MONOPOLIS_URL="https://github-api.monopolis.cloud/deploy/start/$(get_from_event '.repository.full_name')/$(get_from_event '.inputs.deployment_id')"

echo ::set-output name=environment_map::$(curl --fail \
                                              -X POST "${MONOPOLIS_URL}" \
                                              -H "Authorization: Bearer ${GITHUB_TOKEN}")
