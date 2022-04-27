### Configs

- Service and Environment specific configs are managed here.
- Each service configs can be found at following path
```
configs/serviceName/environment/app-config.yaml
```

### helm

- helm charts are prepared as common templated approach 
- Parsing helm arguments during the deployment would take the dynamic inputs per environment and per application specific need

eg; 

```
helm install ppro-sample-service ./appchart --set tag=1.2 
 
 or

 helm install pg-service ./appchart --set service.type=ClusterIP

 ```

 
