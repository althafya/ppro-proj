#!/bin/bash
# author: Althaf
# install minikube on mac OS 

function install {
    echo "--- Start Installing minikube ---"
    # check minikube is already installed
    minikube status |grep 'kubelet: Running' 2> /dev/null
    if [ $? -eq 0 ];then
        echo "INFO: minikube is already installed!"
        alias kubectl="minikube kubectl --"
        return 1
    else 
        echo "INFO: Downloading minikube ..."
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
        minikube start 
        alias kubectl="minikube kubectl --"
        return 0
    fi
    
}

# run 
install 


