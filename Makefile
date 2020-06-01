include .env
export

FABRIC_CA_NAME	:= smartbcity/commune-sandbox-ca
FABRIC_CA_IMG	:= ${FABRIC_CA_NAME}:${VERSION}
FABRIC_CA_LATEST := ${FABRIC_CA_NAME}:latest

FABRIC_PEER_NAME	:= smartbcity/commune-sandbox-peer
FABRIC_PEER_IMG	:= ${FABRIC_PEER_NAME}:${VERSION}
FABRIC_PEER_LATEST := ${FABRIC_PEER_NAME}:latest

FABRIC_ORDERER_NAME	:= smartbcity/commune-sandbox-orderer
FABRIC_ORDERER_IMG	:= ${FABRIC_ORDERER_NAME}:${VERSION}
FABRIC_ORDERER_LATEST := ${FABRIC_ORDERER_NAME}:latest

FABRIC_CLI_NAME	:= smartbcity/commune-sandbox-cli
FABRIC_CLI_IMG	:= ${FABRIC_CLI_NAME}:${VERSION}
FABRIC_CLI_LATEST := ${FABRIC_CLI_NAME}:latest

FABRIC_SSM_REST_NAME	:= smartbcity/commune-sandbox-ssm-rest
FABRIC_SSM_REST_IMG	:= ${FABRIC_SSM_REST_NAME}:${VERSION}
FABRIC_SSM_REST_LATEST := ${FABRIC_SSM_REST_NAME}:latest

SSM_HERACLES_API_REST_VERSION ?=
SSM_VERSION ?=

ifndef CURRENT_VERSION
	SSM_HERACLES_API_REST_VERSION := latest
endif

ifndef SSM_VERSION
	SSM_VERSION := latest
endif

clean: clean-ssm-rest

package: package-ca package-peer package-orderer package-cli package-ssm-rest

push: push-ca push-peer push-orderer push-cli push-ssm-rest

push-latest: push-latest-ca push-latest-peer push-latest-orderer push-latest-cli push-latest-ssm-rest

package-ca:
	@docker build \
         --build-arg COOP_CA_HOSTNAME=$$CA_HOSTNAME \
         --build-arg COOP_PEER_DOMAIN=$$cli_ORGA \
         --build-arg ca__CA_KEYFILE=$$ca__CA_KEYFILE \
         --build-arg ca__TLS_KEYFILE=$$ca__TLS_KEYFILE \
         --build-arg ca__ADMIN=$$ca__ADMIN \
         --build-arg ca__PASSWD=$$ca__PASSWD \
         -f docker/Ca_Dockerfile \
         -t ${FABRIC_CA_IMG} .

push-ca:
	@docker push ${FABRIC_CA_IMG}

push-latest-ca:
	@docker tag ${FABRIC_CA_IMG} ${FABRIC_CA_LATEST}
	@docker push ${FABRIC_CA_LATEST}

package-peer:
	@docker build \
		--build-arg COOP_PEER=peer0 \
    	--build-arg COOP_PEER_MSP=$$peer_msp \
    	--build-arg COOP_PEER_DOMAIN=$$cli_ORGA \
    	-f docker/Peer_Dockerfile \
    	-t ${FABRIC_PEER_IMG} .

push-peer:
	@docker push ${FABRIC_PEER_IMG}

push-latest-peer:
	@docker tag ${FABRIC_PEER_IMG} ${FABRIC_PEER_LATEST}
	@docker push ${FABRIC_PEER_LATEST}

package-orderer:
	docker build \
    	--build-arg COOP_CA_DOMAIN=$$orderer_org \
    	--build-arg COOP_ORDERER_HOSTNAME=$$orderer_hostname \
    	-f docker/Orderer_Dockerfile \
    	-t ${FABRIC_ORDERER_IMG} .

push-orderer:
	@docker push ${FABRIC_ORDERER_IMG}

push-latest-orderer:
	@docker tag ${FABRIC_ORDERER_IMG} ${FABRIC_ORDERER_LATEST}
	@docker push ${FABRIC_ORDERER_LATEST}

package-cli:
	@mkdir build -p
	@sed s/__SSM_VERSION__/${SSM_VERSION}/ docker/Cli_Dockerfile > build/Cli_Dockerfile
	@docker build \
    	--build-arg COOP_CA_DOMAIN=$$orderer_org \
    	--build-arg COOP_PEER=peer0 \
    	--build-arg COOP_PEER_DOMAIN=$$cli_ORGA \
    	--build-arg COOP_PEER_MSP=$$peer_msp \
    	--build-arg CLI_USER=$$cli_user \
    	--build-arg SSM_VERSION=$$SSM_VERSION \
    	-f build/Cli_Dockerfile \
    	-t ${FABRIC_CLI_IMG} .

push-cli:
	@docker push ${FABRIC_CLI_IMG}

push-latest-cli:
	@docker tag ${FABRIC_CLI_IMG} ${FABRIC_CLI_LATEST}
	@docker push ${FABRIC_CLI_LATEST}

clean-ssm-rest:
	@rm -fr build

package-ssm-rest: clean-ssm-rest
	@mkdir build -p
	@sed s/__SSM_HERACLES_API_REST_VERSION__/${SSM_HERACLES_API_REST_VERSION}/ docker/SsmRest_Dockerfile > build/SsmRest_Dockerfile
	@docker build \
    	--build-arg coop_channel=$$coop_channel \
    	--build-arg coop_ccid=$$coop_ccid \
		--build-arg coop_user_org=$$coop_user_org \
		--build-arg coop_endorsers=$$coop_endorsers \
    	--build-arg ca__ADMIN=$$ca__ADMIN \
    	--build-arg ca__PASSWD=$$ca__PASSWD \
    	-f build/SsmRest_Dockerfile \
    	-t ${FABRIC_SSM_REST_IMG} .

push-ssm-rest:
	@docker push ${FABRIC_SSM_REST_IMG}

push-latest-ssm-rest:
	@docker tag ${FABRIC_SSM_REST_IMG} ${FABRIC_SSM_REST_LATEST}
	@docker push ${FABRIC_SSM_REST_LATEST}
