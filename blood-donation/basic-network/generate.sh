#!/bin/sh

export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=ch

# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*

# generate crypto material
./bin/cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

# generate genesis block for orderer
mkdir config
./bin/configtxgen -profile OrdererGenesis -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

# generate channel 1 configuration transaction
./bin/configtxgen -profile Channel1 -outputCreateChannelTx ./config/channel1.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# generate anchor peer transaction
./bin/configtxgen -profile Channel1 -outputAnchorPeersUpdate ./config/BloodOrganchors.tx -channelID $CHANNEL_NAME -asOrg BloodOrg
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for BloodOrg... Channel1"
  exit 1
fi

# generate anchor peer transaction
./bin/configtxgen -profile Channel1 -outputAnchorPeersUpdate ./config/DonorOrganchors.tx -channelID $CHANNEL_NAME -asOrg DonorOrg
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for DonorOrg... Channel1"
  exit 1
fi

# generate anchor peer transaction
./bin/configtxgen -profile Channel1 -outputAnchorPeersUpdate ./config/HospitalOrganchors.tx -channelID $CHANNEL_NAME -asOrg HospitalOrg
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for DonorOrg... Channel1"
  exit 1
fi