## Provision Entire Cluster including the service
  ```
  cd ppro-proj/devops/deploy/
  bash deploy-e2e-wrapper.sh 
  ```

## Infra as a Code (Config - .deploy-e2e.config)
```
cat deploy-e2e.config
namespaces=('dev','prod')
services_to_be_deployed=('ppro-sample-service')
```