include .env
export

FABRIC_CA_NAME	:= civisblockchain/bclan-ca
FABRIC_CA_IMG	:= ${FABRIC_CA_NAME}:${VERSION}
FABRIC_CA_LATEST := ${FABRIC_CA_NAME}:latest

FABRIC_PEER_NAME	:= civisblockchain/bclan-peer
FABRIC_PEER_IMG	:= ${FABRIC_PEER_NAME}:${VERSION}
FABRIC_PEER_LATEST := ${FABRIC_PEER_NAME}:latest

FABRIC_ORDERER_NAME	:= civisblockchain/bclan-orderer
FABRIC_ORDERER_IMG	:= ${FABRIC_ORDERER_NAME}:${VERSION}
FABRIC_ORDERER_LATEST := ${FABRIC_ORDERER_NAME}:latest

FABRIC_CLI_NAME	:= civisblockchain/bclan-cli
FABRIC_CLI_IMG	:= ${FABRIC_CLI_NAME}:${VERSION}
FABRIC_CLI_LATEST := ${FABRIC_CLI_NAME}:latest

FABRIC_COOP_REST_NAME	:= civisblockchain/bclan-coop-rest
FABRIC_COOP_REST_IMG	:= ${FABRIC_COOP_REST_NAME}:${VERSION}
FABRIC_COOP_REST_LATEST := ${FABRIC_COOP_REST_NAME}:latest

clean: clean-coop-rest

package: package-ca package-peer package-orderer package-cli package-coop-rest

push: push-ca push-peer push-orderer push-cli push-coop-rest

push-latest: push-latest-ca push-latest-peer push-latest-orderer push-latest-cli push-latest-coop-rest

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
	docker build \
    	--build-arg COOP_CA_DOMAIN=$$orderer_org \
    	--build-arg COOP_PEER=peer0 \
    	--build-arg COOP_PEER_DOMAIN=$$cli_ORGA \
    	--build-arg COOP_PEER_MSP=$$peer_msp \
    	--build-arg CLI_USER=$$cli_user \
    	-f docker/Cli_Dockerfile \
    	-t ${FABRIC_CLI_IMG} .

push-cli:
	@docker push ${FABRIC_CLI_IMG}

push-latest-cli:
	@docker tag ${FABRIC_CLI_IMG} ${FABRIC_CLI_LATEST}
	@docker push ${FABRIC_CLI_LATEST}

clean-coop-rest:
	@rm -fr build

package-coop-rest: clean-coop-rest
	@mkdir build
	@sed s/__VERSION__/${VERSION}/ docker/CoopRest_Dockerfile > build/CoopRest_Dockerfile
	@docker build \
    	--build-arg coop_channel=$$coop_channel \
    	--build-arg coop_ccid=$$coop_ccid \
		--build-arg coop_user_org=$$coop_user_org \
		--build-arg coop_endorsers=$$coop_endorsers \
    	--build-arg ca__ADMIN=$$ca__ADMIN \
    	--build-arg ca__PASSWD=$$ca__PASSWD \
    	-f build/CoopRest_Dockerfile \
    	-t ${FABRIC_COOP_REST_IMG} .

push-coop-rest:
	@docker push ${FABRIC_COOP_REST_IMG}

push-latest-coop-rest:
	@docker tag ${FABRIC_COOP_REST_IMG} ${FABRIC_COOP_REST_LATEST}
	@docker push ${FABRIC_COOP_REST_LATEST}
