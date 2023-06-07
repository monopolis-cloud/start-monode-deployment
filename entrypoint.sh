#!/bin/ash -xe

get_from_event() {
  jq -r "$1" "${GITHUB_EVENT_PATH}"
}

if jq --exit-status '.inputs.ROLLOUT_DEPLOYMENT_ID' "$GITHUB_EVENT_PATH" >/dev/null; then
  MONOPOLIS_URL="https://api.monopolis.cloud/v1/rollout/start/$(get_from_event '.repository.name')/$(get_from_event '.inputs.ROLLOUT_DEPLOYMENT_ID')"

  CONFIGURATIONS=$(curl --fail -X POST "${MONOPOLIS_URL}" -H "Authorization: Bearer ${MONOPOLIS_API_KEY}")
  echo ::set-output name=configurations::$CONFIGURATIONS

  UPSTREAM=$(echo "$CONFIGURATIONS" | jq 'to_entries | map(select(.value.type == "upstream")) | map(.key)')
  echo ::set-output name=upstream-crosschecks::$UPSTREAM

  DOWNSTREAM=$(echo "$CONFIGURATIONS" | jq 'to_entries | map(select(.value.type == "downstream")) | map(.key)')
  echo ::set-output name=downstream-crosschecks::$DOWNSTREAM

else
  echo ::set-output name=configurations::"{}"
  echo ::set-output name=upstream-crosschecks::"[]"
  echo ::set-output name=downstream-crosschecks::"[]"
fi
