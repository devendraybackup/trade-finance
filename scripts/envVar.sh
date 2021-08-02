#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/tlscacerts/tlsca.tfbc.com-cert.pem
export PEER0_BUYER_CA=${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/ca.crt
export PEER0_SELLER_CA=${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/ca.crt
export PEER0_BANK_CA=${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/ca.crt

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    echo "SetGlobal - Devendra" 
    export CORE_PEER_LOCALMSPID="BuyerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BUYER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/buyer.tfbc.com/users/Admin@buyer.tfbc.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="SellerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_SELLER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/seller.tfbc.com/users/Admin@seller.tfbc.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="BankMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BANK_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/bank.tfbc.com/users/Admin@bank.tfbc.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.buyer.tfbc.com:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.seller.tfbc.com:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.bank.tfbc.com:8051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    if [ $1 -eq 1 ]; then
      PEER="peer0.buyer"
    elif [ $1 -eq 2 ]; then
      PEER="peer0.seller"
    elif [ $1 -eq 3 ]; then
      PEER="peer0.bank"
    else
      errorln "Org ---- unknown"
    fi
    echo $PEER
    echo "Test devendra---"
    #PEER="peer0.org$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    if [ $1 -eq 1 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_BUYER_CA")
    elif [ $1 -eq 2 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_SELLER_CA")
    elif [ $1 -eq 3 ]; then
      TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_BANK_CA")
    else
      errorln "Org ---- unknown"
    fi 

    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
