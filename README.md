
# ppro-project 

### Project Description

This is a sample project with Node JS based restapi with Postgres as back-end running in a container.
```
localhost:8000/get <====> restapi Container <=====> Postgres Container
```

### Configs

Configurations are managed via individual service based, which would make easy for anyone to go ahead and make changes on config files instead of Source Code.

- deploy -> devops -> configs -> service -> <environment> -> app-config.yaml

-  app-config.yaml will be exposed inside app container. The same will be used by app (node js) code.

### Build 
  
  Application Source code (Root path) will have Dockerfile 
  
- ppro-sample-service -> Dockerfile 
  
  ```
  docker build -t <servicename>:latest .
  ```
  

### Deploy 
  
  for deployment, we are using helm charts which would handle 
  - deploy
  - configmap 
  - service 
  - HPA 
  
  in order to run helm charts we could simply update values.yaml to have dynamic args for environment specific.
  
  ```
  cd ppro-proj/devops/deploy/helm/app
  helm upgrade --install ppro-sample-service ./appchart 
  ```
  
  ```
  cd ppro-proj/devops/deploy/helm/db 
  helm upgrade --install ppro-sample-service ./dbchart 
  ```
  
### Provision Entire Cluster 
  ```
  cd ppro-proj/devops/deploy/
  bash deploy-e2e-wrapper.sh 
  ```

### Source Code Tree for Devops  

<img width="311" alt="image" src="https://user-images.githubusercontent.com/5214795/165442677-eee0570e-9997-4b60-9824-4ab7f955982a.png">
  
### Source Code Tree for ppro-sample-service  

<img width="170" alt="image" src="https://user-images.githubusercontent.com/5214795/165442736-63ce862e-616e-4a03-a0c1-565142e125b1.png">


