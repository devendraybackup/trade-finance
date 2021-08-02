#!/bin/bash

function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp --csr.hosts peer0.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts peer0.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml
}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp --csr.hosts peer0.org2.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls --enrollment.profile tls --csr.hosts peer0.org2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/org2.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}


function createBuyer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/buyer.tfbc.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/buyer.tfbc.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-buyer --tls.certfiles ${PWD}/organizations/fabric-ca/buyer/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-buyer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-buyer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-buyer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-buyer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/buyer.tfbc.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-buyer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/buyer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-buyer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/buyer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-buyer --id.name buyeradmin --id.secret buyeradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/buyer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-buyer -M ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/msp --csr.hosts peer0.buyer.tfbc.com --tls.certfiles ${PWD}/organizations/fabric-ca/buyer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-buyer -M ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls --enrollment.profile tls --csr.hosts peer0.buyer.tfbc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/buyer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/tlsca/tlsca.buyer.tfbc.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/ca
  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.buyer.tfbc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/ca/ca.buyer.tfbc.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-buyer -M ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/users/User1@buyer.tfbc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/buyer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/users/User1@buyer.tfbc.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://buyeradmin:buyeradminpw@localhost:7054 --caname ca-buyer -M ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/users/Admin@buyer.tfbc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/buyer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/buyer.tfbc.com/users/Admin@buyer.tfbc.com/msp/config.yaml
}

function createSeller() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/seller.tfbc.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/seller.tfbc.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-seller --tls.certfiles ${PWD}/organizations/fabric-ca/seller/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-seller.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-seller.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-seller.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-seller.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/seller.tfbc.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-seller --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/seller/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-seller --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/seller/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-seller --id.name selleradmin --id.secret selleradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/seller/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-seller -M ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/msp --csr.hosts peer0.seller.tfbc.com --tls.certfiles ${PWD}/organizations/fabric-ca/seller/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-seller -M ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls --enrollment.profile tls --csr.hosts peer0.seller.tfbc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/seller/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/seller.tfbc.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/seller.tfbc.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/seller.tfbc.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/seller.tfbc.com/tlsca/tlsca.seller.tfbc.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/seller.tfbc.com/ca
  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/peers/peer0.seller.tfbc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/seller.tfbc.com/ca/ca.seller.tfbc.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-seller -M ${PWD}/organizations/peerOrganizations/seller.tfbc.com/users/User1@seller.tfbc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/seller/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/seller.tfbc.com/users/User1@seller.tfbc.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://selleradmin:selleradminpw@localhost:8054 --caname ca-seller -M ${PWD}/organizations/peerOrganizations/seller.tfbc.com/users/Admin@seller.tfbc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/seller/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/seller.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/seller.tfbc.com/users/Admin@seller.tfbc.com/msp/config.yaml
}


function createOrdererTfbc() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/tfbc.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/tfbc.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/tfbc.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp --csr.hosts orderer.tfbc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/tfbc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls --enrollment.profile tls --csr.hosts orderer.tfbc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/tlscacerts/tlsca.tfbc.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/tfbc.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/tfbc.com/msp/tlscacerts/tlsca.tfbc.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/tfbc.com/users/Admin@tfbc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/tfbc.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/tfbc.com/users/Admin@tfbc.com/msp/config.yaml
}


function createBank() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/bank.tfbc.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/bank.tfbc.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-bank --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bank.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bank.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bank.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bank.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/bank.tfbc.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-bank --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-bank --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-bank --id.name bankadmin --id.secret bankadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/msp --csr.hosts peer0.bank.tfbc.com --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls --enrollment.profile tls --csr.hosts peer0.bank.tfbc.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.tfbc.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.tfbc.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.tfbc.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.tfbc.com/tlsca/tlsca.bank.tfbc.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.tfbc.com/ca
  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/peers/peer0.bank.tfbc.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/bank.tfbc.com/ca/ca.bank.tfbc.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.tfbc.com/users/User1@bank.tfbc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.tfbc.com/users/User1@bank.tfbc.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://bankadmin:bankadminpw@localhost:8054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.tfbc.com/users/Admin@bank.tfbc.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.tfbc.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.tfbc.com/users/Admin@bank.tfbc.com/msp/config.yaml
}