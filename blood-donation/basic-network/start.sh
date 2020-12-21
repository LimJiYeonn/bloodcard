#!/bin/bash
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

docker rm -f $(docker ps -aq)
docker-compose -f docker-compose.yaml down
docker-compose -f docker-compose.yaml up -d 
#orderer.bloodcard.com peer0.blood.bloodcard.com peer1.blood.bloodcard.com peer0.donor.bloodcard.com peer1.donor.bloodcard.com cli

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec cli peer channel create -o orderer.bloodcard.com:7050 -c ch -f /etc/hyperledger/configtx/channel1.tx

# Join peer0.blood.bloodcard.com to the channel and Update the Anchor Peers in Channel1
docker exec cli peer channel join -b ch.block
docker exec cli peer channel update -o orderer.bloodcard.com:7050 -c ch -f /etc/hyperledger/configtx/BloodOrganchors.tx

# Join peer1.blood.bloodcard.com to the channel
docker exec -e "CORE_PEER_ADDRESS=peer1.blood.bloodcard.com:7051" cli peer channel join -b ch.block

# Join peer0.donor.bloodcard.com to the channel and update the Anchor Peers in Channel1
docker exec -e "CORE_PEER_LOCALMSPID=DonorOrg" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/donor.bloodcard.com/users/Admin@donor.bloodcard.com/msp" -e "CORE_PEER_ADDRESS=peer0.donor.bloodcard.com:7051" cli peer channel join -b ch.block
docker exec -e "CORE_PEER_LOCALMSPID=DonorOrg" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/donor.bloodcard.com/users/Admin@donor.bloodcard.com/msp" -e "CORE_PEER_ADDRESS=peer0.donor.bloodcard.com:7051" cli peer channel update -o orderer.bloodcard.com:7050 -c ch -f /etc/hyperledger/configtx/DonorOrganchors.tx

# Join peer0.donor.bloodcard.com to the channel
docker exec -e "CORE_PEER_LOCALMSPID=DonorOrg" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/donor.bloodcard.com/users/Admin@donor.bloodcard.com/msp" -e "CORE_PEER_ADDRESS=peer1.donor.bloodcard.com:7051" cli peer channel join -b ch.block




# Join peer0.hospital.bloodcard.com to the channel and update the Anchor Peers in Channel1
docker exec -e "CORE_PEER_LOCALMSPID=HospitalOrg" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospital.bloodcard.com/users/Admin@hospital.bloodcard.com/msp" -e "CORE_PEER_ADDRESS=peer0.hospital.bloodcard.com:7051" cli peer channel join -b ch.block
docker exec -e "CORE_PEER_LOCALMSPID=HospitalOrg" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospital.bloodcard.com/users/Admin@hospital.bloodcard.com/msp" -e "CORE_PEER_ADDRESS=peer0.hospital.bloodcard.com:7051" cli peer channel update -o orderer.bloodcard.com:7050 -c ch -f /etc/hyperledger/configtx/HospitalOrganchors.tx

# Join peer0.hospital.bloodcard.com to the channel
docker exec -e "CORE_PEER_LOCALMSPID=HospitalOrg" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospital.bloodcard.com/users/Admin@hospital.bloodcard.com/msp" -e "CORE_PEER_ADDRESS=peer1.hospital.bloodcard.com:7051" cli peer channel join -b ch.block
