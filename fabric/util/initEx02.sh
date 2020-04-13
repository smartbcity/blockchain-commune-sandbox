#!/usr/bin/env bash

source /opt/commune-sandbox/util/env

#Join network
echo 'Join channel ${CHANNEL}'
peer channel create -o ${ORDERER_ADDR} -c ${CHANNEL} -f /etc/hyperledger/config/${CHANNEL}.tx --tls --cafile ${ORDERER_CERT}
peer channel join -b ${CHANNEL}.block

#Install and instantiate ex02
echo 'Install chaincode ex02'
peer chaincode install -n ex02 -v 1.0 -p commune-sandbox/go/chaincode_example02/
echo 'Instantiate chaincode ex02'
peer chaincode instantiate -o ${ORDERER_ADDR} --tls --cafile ${ORDERER_CERT} -C ${CHANNEL} -n ex02 -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('BlockchainLANCoopMSP.member')"
sleep 5
echo 'Query chaincode ex02'
peer chaincode query -C ${CHANNEL} -n ex02 -c '{"Args":["query","a"]}'
