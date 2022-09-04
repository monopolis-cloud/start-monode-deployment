# Monopolis: Start Monode Rollout

This action is designed to work with Monopolis rollout workflows only. It starts a deployment from a GitHub Actions pipeline and returns Crosscheck configurations for running Crosschecks.

## Action inputs
None. These are picked up automatically from the input event which triggered the workflow.

## Action outputs
| Name                       | Sample value | Description                                                                        |
|----------------------------|--------------|------------------------------------------------------------------------------------|
| configurations | {}           | JSON map of all crosscheck configurations, to be used for implementing crosschecks |
| downstream-crosschecks     | ["app2"]     | List of the downstream Monodes to be crosschecked the target environment           |
| upstream-crosschecks       | ["app2"]     | List of the upstream Monodes to be crosschecked the target environment             |

## Example
This example demonstrates the usage.

```yml
name: Example monode deployment

on:
  workflow_dispatch:
    inputs:
      deployment_id:
        description: Deployment ID
        required: true
        type: string

jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - id: start
        uses: monopolis-cloud/start-monode-rollout@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - run: echo deployment
      - run: echo ${{ steps.start.outputs.upstream-crosschecks }}
      - run: echo ${{ steps.start.outputs.downstream-crosschecks }}
      - run: echo ${{ steps.start.outputs.configurations }}
```