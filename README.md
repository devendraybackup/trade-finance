## Prerequisites
Before you begin, you should confirm that you have installed all the prerequisites below on the platform where you will be running Hyperledger Fabric.
https://hyperledger-fabric.readthedocs.io/en/release-2.2/prereqs.html

## Install Hyperledger Fabric 2.2
 Follow this link - https://hyperledger-fabric.readthedocs.io/en/release-2.2/install.html

 It retrieves the following platform-specific binaries:

configtxgen,
configtxlator,
cryptogen,
discover,
idemixgen
orderer,
peer,
fabric-ca-client,
fabric-ca-server


## Set the Path of above Directory in  startTFBC.sh file to fabric-samples
export HYPERLegerFabricSamplePATH=${PWD}/../fabric-samples 

## Install go dependencies

    > x./initGo.sh

## Running the Trade finance network
you can use the ./startTFBC.sh script up a soimple Trade finace network with Buyer , seller and Bank organization , has three organizations with one peereach and a single node raft ordering servie. It also creates channel and deploy chaincode.




