#!/usr/bin/env bash

source /opt/commune-sandbox/util/env
sleep 5
#Join network
echo 'Join channel ${CHANNEL}'
peer channel create -o ${ORDERER_ADDR} -c ${CHANNEL} -f /etc/hyperledger/config/${CHANNEL}.tx --tls --cafile ${ORDERER_CERT}
peer channel join -b ${CHANNEL}.block

#Install and instantiate ssm
source /opt/smartbcity/ssm/env
echo 'Install chaincode ssm'
peer chaincode install /opt/smartbcity/ssm/ssm.pak
echo 'Instantiate chaincode ssm'
peer chaincode instantiate -o ${ORDERER_ADDR} --tls --cafile ${ORDERER_CERT} -C ${CHANNEL} -n ${CHAINCODE} -v ${VERSION} -c $(cat /opt/commune-sandbox/util/init.arg) -P "OR ('BlockchainLANCoopMSP.member')"
sleep 5
echo 'Query chaincode ssm'
peer chaincode query -C ${CHANNEL} -n ${CHAINCODE} -c '{"Args":["list", "user"]}'
