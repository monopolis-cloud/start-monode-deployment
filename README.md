# Monopolis: Start Monode Deployment

This action is designed to work with Monopolis deployments. It starts a deployment from a GitHub Actions pipeline

## Action inputs
None. These are picked up automatically from the input event which triggered the workflow.

## Action outputs
| Name            | Sample value                 | Description                                        |
|-----------------|------------------------------|----------------------------------------------------|
| environment_map | {"app1":"9467c95163a5c56ad"} | JSON map of contents of the deployment environment |

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
      - uses: actions/checkout@v1
      - id: start_monode_deployment
        uses: monoppolis-cloud/start-monopolis-deployment@main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - run: echo deployment
      - run: echo ${{ steps.start_monode_deployment.outputs.environment_map }}
```