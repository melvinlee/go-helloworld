#/bin/sh

set -e 

instuction()
{
    echo 
    echo "Welcome to launch-pad"
    echo "Usage: launch.sh setup"
    echo "Usage: launch.sh build"
    echo "Usage: launch.sh deploy"
    echo
}

export LOCATION=southeastasia
export RESOURCEGROUP=helloworld-rg
export ACR=melvinhub

if [ $# -lt 1 ]; then
    instuction
    exit 1
fi

if [ $1 == "setup" ]; then 

    echo "Launching resource group..."
    echo 
    az group create -l $LOCATION -n $RESOURCEGROUP
    echo 

    echo "Launching Azure Container Registry..."
    echo 
    az acr create -g $RESOURCEGROUP -n $ACR --sku Basic --admin-enabled
    echo 

    exit 0
fi

if [ $1 == "build" ]; then

    echo "Building container..."
    az acr build -r $ACR -f Dockerfile -t go-helloworld .
    echo 
    exit 0
fi

if [ $1 == "deploy" ]; then

    echo "Deploying container..."
    PASSWORD=$(az acr credential show -n $ACR --query "passwords[0].value" | tail -n 1)
	az container create -g $RESOURCEGROUP \
         --name helloworld \
        --image $ACR.azurecr.io/go-helloworld:latest \
        --ports 80 --registry-username $ACR \
        --registry-password $PASSWORD \
        --dns-name-label melvinlee-helloworld
    echo 
    exit 0
fi
