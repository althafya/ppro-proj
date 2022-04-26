#!/bin/bash
# This script will take care of complete provisioning/decomissioning the platform cluster including the services 

cur_path=`pwd|awk -F/ '{print $(NF-1)"/"$NF}'`
if [  $cur_path == "ppro-proj/devops" ]; then 
    export DEVOPS_PATH=`pwd`
    echo $DEVOPS_PATH
else
    echo -e "WARNING: Please navigate to ppro-proj/devops folder and run ... bash deploy-e2e-wrapper.sh"
    exit 2;
fi 

# configs:
export CONFIG_PATH=`pwd`/deploy/configs
export MINIKUBE_PATH=`pwd`/minikube-cluster 
export HELM_PATH=`pwd`/deploy/helm
export SVC_PATH=`dirname \`pwd\``
source .deploy-e2e.config


# functions: 
function checkMinikube() {
    echo -e "\t\t\t Verifying k8s Cluster ...\n"
    cd $MINIKUBE_PATH/
    bash install-minikube.sh 
    return $?
}


function healthCheck() {
    # This function will install kubectl/helm and sanity of k8s cluster 
    echo -e "\n\t\t\t starting Health check!\n"
    kubectl get namespaces 2> /dev/null 
    if [ $? -eq 0 ];then
        for i in `echo $namespaces|sed 's/,/ /g'`
            do 
            kubectl create namespace $i 2>/dev/null
        done 
        echo -e "\n\t\t\t Create Namespaces Completed!\n"
        kubectl get namespaces 2> /dev/null 
        #looks Good
        echo -e "\n\t\t\t Check helm installation\n "
        helm list 2>/dev/null
        if [ $? -eq 0 ];then 
        # looks Good 
        echo -e "\n--------------------------------------------"
        echo -e "\t\t\t\n INFO: Cluster Looks Okay! Congrats... :) \n"
        echo -e "--------------------------------------------"
        else 
            # install helm 
            curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
            chmod 700 get_helm.sh
            ./get_helm.sh
            # check again 
            echo ""
            helm list 2>/dev/null 
            if [ $? -eq 0 ];then 
                echo -e "\n----------------------------------------------------"
                echo -e "\t\t\t\ INFO: Cluster Looks Okay! Congrats... :) "
                echo -e "------------------------------------------------------"
            else 
                echo -e "\t\t\t\n ERROR: please install helm and then re-run the script!\n\t\t\t Something WRONG...."
                exit 2;
            fi 
        fi 
    else 
        echo -e "\t\t\t\n ERROR: please manually install kubectl and helm to proceed further!"
        exit 2;
    fi      

}


function dockerBuild() {
    # create docker build for services
    svc=$1
    cd $SVC_PATH/$svc
    echo -e "\n\n\t\t\t Starting Docker build for app - $svc ....\n"
    sleep 2
    docker build -t $svc:latest .
    docker tag $svc:latest althaf/pprorepo:latest 
    echo -e "\n----------------------------------------------------------------------------------------------"
    echo -e "\t\t\t INFO: Docker build completed for app as althaf/pprorepo:latest (tagged) "
    echo -e "----------------------------------------------------------------------------------------------"
    sleep 1

}


function helmDeploy() {
    svc=$1
    environ=$2 
    echo -e "\n\n###################################################################################"
    echo -e "\t\t\t INFO: starting helm Deployment for db(postgres) - $environ...!"
    echo -e "####################################################################################\n\n"
    sleep 2
    #db deploy 
        #set configs:
        cd $CONFIG_PATH/$svc/$environ
        export DB_PASS=`grep DB_PASS app-config.yaml|awk -F: '{print $2}'|sed 's/"//g'|sed 's/[ \t]*$//'|tr -d '\n'|base64`    
        export PORT=`grep PORT app-config.yaml|awk -F: '{print $2}'|sed 's/"//g'|sed 's/[ \t]*$//'` 
        cd $HELM_PATH/db/
        helm upgrade --install pg-service --namespace $environ  ./dbchart 
        if [ $? -eq 0 ];then 
            echo -e "\n------------------------------------------------------"
            echo -e "\t\t\t pg-service is Deployed in $environ Successfully!"
            kubectl get all  -n $environ 
            echo -e "-------------------------------------------------------\n\n"
            sleep 2

            #app deploy 
                # copy config file to helm chart for configmap
                echo -e "\n\n###################################################################################"
                echo -e "\t\t\t INFO: starting helm Deploy for app($svc) - $environ...!"
                echo -e "####################################################################################\n\n"
                cp $CONFIG_PATH/$svc/$environ/app-config.yaml $HELM_PATH/app/appchart/
                cd $HELM_PATH/app/
                helm upgrade --install $svc  --namespace=$environ --set tag=latest ./appchart   
        fi 
        echo -e "\n\t\t\t\t---- End of $environ Deployment -----\n"
        sleep 1

}

# to install    
function installSetup() {
    clear
    echo -e "\n\n Starting Installation ...."
    sleep 1
    # check if already exist
    checkMinikube
    if [[ $? -eq 0 || $? -eq 1 ]];then 
        healthCheck
        if [ $? -eq 0 ];then 
            # parse service names from config and run docker build
            for i in `echo $services_to_be_deployed|sed 's/,/ /g'`
                do 
                    dockerBuild $i
                    if [ $? -eq 0 ];then 
                        # go for Deploy 
                        for j in `echo $namespaces|sed 's/,/ /g'`
                            do 
                                helmDeploy $i $j
                        done 
                    fi 
            done
            kubectl port-forward svc/ppro-svc 8000:8000 -n prod &
            kubectl port-forward svc/ppro-svc 8001:8000 -n dev &
            clear 
            echo -e "\n-------------------------------------------------------------------------"
            echo -e " Congrats... Now you can access Prod by hitting http://localhost:8000/get"
            echo -e " Congrats... Now you can access dev by hitting http://localhost:8001/get"
            echo -e "\n-------------------------------------------------------------------------\n"
        fi  
            
        else 
        echo "ERROR: please install or check minikube cluster!Something WRONG..."
    fi    
}


# to uninstall
function destroySetup() {
    echo -e "\n\t\t\t --------------- destroying namespaces --------------\n"
    for j in `echo $namespaces|sed 's/,/ /g'`
        do
        kubectl delete namespace $j 2>/dev/null
        echo "$j ..."
        done 
echo -e "\n\t\t\t --------------- Completed ---------------\n"
}


# Run 
clear
       echo ""
       echo -e "\n----------------------- Please select option to Proceed setting up cluster or Decommisioning ----------------------\n" 
       echo -e "\t\t\t  1) Install minikube K8s cluster and setup Service ?"
       echo -e "\t\t\t  2) Decommission minikube k8s cluster and services ?\n"
       read -p "(1/2)?:" option

case $option in 
    1) 
    installSetup ;;
    2) 
    destroySetup ;;

esac 