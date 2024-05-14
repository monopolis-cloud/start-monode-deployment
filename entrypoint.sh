#!/bin/ash -xe

get_from_event() {
  jq -r "$1" "${GITHUB_EVENT_PATH}"
}

if jq --exit-status '.inputs.ROLLOUT_DEPLOYMENT_ID' "$GITHUB_EVENT_PATH" >/dev/null; then
  MONOPOLIS_URL="https://api.monopolis.cloud/v1/rollout/start/$(get_from_event '.repository.name')/$(get_from_event '.inputs.ROLLOUT_DEPLOYMENT_ID')"

  CONFIGURATIONS=$(curl --fail -X POST "${MONOPOLIS_URL}" -H "Authorization: Bearer ${MONOPOLIS_API_KEY}")
  echo "configurations=${CONFIGURATIONS}" >> "$GITHUB_OUTPUT"

  UPSTREAM=$(echo "$CONFIGURATIONS" | jq 'to_entries | map(select(.value.type == "upstream")) | map(.key)')
  echo "upstream-crosschecks=${UPSTREAM}" >> "$GITHUB_OUTPUT"

  DOWNSTREAM=$(echo "$CONFIGURATIONS" | jq 'to_entries | map(select(.value.type == "downstream")) | map(.key)')
  echo "downstream-crosschecks=${DOWNSTREAM}" >> "$GITHUB_OUTPUT"

else
  echo 'configurations={}' >> "$GITHUB_OUTPUT"
  echo 'upstream-crosschecks=[]' >> "$GITHUB_OUTPUT"
  echo 'downstream-crosschecks=[]' >> "$GITHUB_OUTPUT"
fi
