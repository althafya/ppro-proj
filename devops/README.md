workflow:
    create namespace dev 
    Build:
        1: app docker build 
        2: ensure to include the init as well
        2: tag them 
        3: push to docker hub # will use my credential for time being and can be replaced by env file
    Deploy DB: 
        1: secrets to be created for pg  (should be update in helm)
        2: deploy
        3: svc 
    Deploy restapi:
        1: configmap to be created for api (should be update in helm)
        2: take the latest tag as an input and replace the helm deploy
        2: deploy
        3: svc


    docker run -it -e SVC="ppro-sample-service" -e ENV="dev" -e TAG="" --mount src=`pwd`,target=/deploy,type=bind ppro-config-base:1 /bin/sh