export HYPERLegerFabricSamplePATH=${PWD}/../fabric-samples
./network.sh down
./network.sh up createChannel  -s couchdb
#./network.sh deployCC -ccn basic -ccp ../chaincode/TFBC/go/ -ccl go
./network.sh deployCC -ccn tfbc -ccv 1 -cci NA -ccl go -ccp chaincode/TFBC/go/ 

#./network.sh deployCC -ccn marble -ccv 1 -cci NA -ccl go -ccp ../chaincode/marbles02/go/peer chaincode invoke -o orderer.tfbc.com:7050 --tls --cafile ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/tlscacerts/tlsca.tfbc.com-cert.pem -C mychannel -n tfbc --peerAddresses peer0.buyer.tfbc.com:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Buyer.tfbc.com/peers/peer0.Buyer.tfbc.com/tls/ca.crt --peerAddresses peer0.seller.tfbc.com:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Seller.tfbc.com/peers/peer0.Seller.tfbc.com/tls/ca.crt --peerAddresses peer0.bank.tfbc.com:8051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Bank.tfbc.com/peers/peer0.Bank.tfbc.com/tls/ca.crt -c '{"Args":["placeOrder","PO100","2021-09-04","Buyer","2021-07-30","Seller","5600"]}'