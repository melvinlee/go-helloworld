LOCATION = southeastasia
RG_NAME = go-helloworld-rg
MY_ACR =  melvinleehub
PASSWORD =$(shell az acr credential show -n $(MY_ACR) --query passwords[0].value | tail -n 1)

.PHONY: setup
setup:
	az group create -l $(LOCATION) -n $(RG_NAME)
	az acr create -g $(RG_NAME) -n $(MY_ACR) --sku Basic --admin-enabled
	az acr build -r $(MY_ACR) -f Dockerfile -t go-helloworld .

# .PHONY: build
# build: 
# 	# docker build -t $(MY_ACR).azurecr.io/go-helloworld .
# 	az acr build -r $(MY_ACR) -f Dockerfile -t go-helloworld .

# .PHONY: push
# push: 
# 	az acr login -n $(MY_ACR)
# 	docker push $(MY_ACR).azurecr.io/go-helloworld

.PHONY: run
run:
	az container create -g $(RG_NAME) --name helloworld --image $(MY_ACR).azurecr.io/go-helloworld:latest --ports 80 --registry-username $(MY_ACR) --registry-password $(PASSWORD) --dns-name-label melvinlee-helloworld

.PHONY: cleanup
cleanup:
	az group delete -g $(RG_NAME) -y