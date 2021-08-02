/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

/*
 * The sample smart contract for documentation topic:
 * Trade Finance Use Case - WORK IN  PROGRESS
 */

 /*
// ==== Invoke marbles ====
 peer chaincode invoke -C mychannel -o orderer.tfbc.com:7050 --tls --cafile ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/tlscacerts/tlsca.tfbc.com-cert.pem -n basic -c '{"Args":["requestLC","lc100","2021-07-31","Buyer","Bank","Seller","5600"]}'
 peer chaincode invoke -C mychannel -o orderer.tfbc.com:7050 --tls --cafile ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/tlscacerts/tlsca.tfbc.com-cert.pem -n marble -c '{"Args":["initMarble","marble1","blue","35","tom"]}'

 peer chaincode invoke -C mychannel -o orderer.tfbc.com:7050 --tls --cafile ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/tlscacerts/tlsca.tfbc.com-cert.pem -n basic -c '{"Args":["getLC","lc100"]}'
// peer chaincode invoke -C mychannel -n basic -c '{"Args":["initMarble","marble3","blue","70","tom"]}'
// peer chaincode invoke -C mychannel -n basic -c '{"Args":["transferMarble","marble2","jerry"]}'
// peer chaincode invoke -C mychannel -n basic -c '{"Args":["transferbasicBasedOnColor","blue","jerry"]}'
// peer chaincode invoke -C mychannel -n basic -c '{"Args":["delete","marble1"]}'
// 

peer chaincode query -C mychannel -n basic -c '{"Args":["getLC","lc100"]}'

peer chaincode query -C mychannel -n marble -c '{"Args":["readMarble","marble1"]}'

export CORE_PEER_ADDRESS=localhost:7051
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="BuyerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.Buyer.tfbc.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Buyer.tfbc.com/users/Admin@Buyer.tfbc.com/msp
export CORE_PEER_ADDRESS=peer0.buyer.tfbc.com:7051
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.tfbc.com --tls --cafile ${PWD}/organizations/ordererOrganizations/tfbc.com/orderers/orderer.tfbc.com/msp/tlscacerts/tlsca.tfbc.com-cert.pem -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Buyer.tfbc.com/peers/peer0.Buyer.tfbc.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Seller.tfbc.com/peers/peer0.Seller.tfbc.com/tls/ca.crt --peerAddresses localhost:8051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Bank.tfbc.com/peers/peer0.Bank.tfbc.com/tls/ca.crt -c '{"Args":["requestLC","lc100","2021-07-31","Buyer","Bank","Seller","5600"]}'



export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="BuyerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/buyer.tfbc.com/peers/peer0.Buyer.tfbc.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Buyer.tfbc.com/users/Admin@Buyer.tfbc.com/msp
export CORE_PEER_ADDRESS=peer0.buyer.tfbc.com:7051



*/
 package main


 import (
	 "bytes"
	 "encoding/json" 
	 "fmt"
	 "strconv"
	 "time"
	 "github.com/hyperledger/fabric-chaincode-go/shim"
	 sc "github.com/hyperledger/fabric-protos-go/peer"
 )
 
 // Define the Smart Contract structure
 type SmartContract struct {
 }
 
 type PurchaseOrder struct {
	PoId			string		`json:"poId"`
	DeliveryDate		string		`json:"deliveryDate"`
	Buyer    string   `json:"buyer"`
	OrderDate		string		`json:"orderDate"`
	Seller		string		`json:"seller"`
	Amount			int		`json:"amount"`
	Status			string		`json:"status"`
}
 
 // Define the letter of credit
 type LetterOfCredit struct {
	 LCId			string		`json:"lcId"`
	 ExpiryDate		string		`json:"expiryDate"`
	 Buyer    string   `json:"buyer"`
	 Bank		string		`json:"bank"`
	 Seller		string		`json:"seller"`
	 Amount			int		`json:"amount"`
	 Status			string		`json:"status"`
	 PoId			string		`json:"poId"`
 }
 
 
 func (s *SmartContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	 return shim.Success(nil)
 }
 
 func (s *SmartContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {
 
	 // Retrieve the requested Smart Contract function and arguments
	 function, args := APIstub.GetFunctionAndParameters()
	 // Route to the appropriate handler function to interact with the ledger appropriately
	 if function == "requestLC" {
		 return s.requestLC(APIstub, args)
	 } else if function == "issueLC" {
		 return s.issueLC(APIstub, args)
	 } else if function == "acceptLC" {
		 return s.acceptLC(APIstub, args)
	 }else if function == "getLC" {
		 return s.getLC(APIstub, args)
	 }else if function == "getLCHistory" {
		 return s.getLCHistory(APIstub, args)
	 }else if function == "placeOrder" {
		return s.placeOrder(APIstub, args)
	}else if function == "acceptPO" {
		return s.acceptPO(APIstub, args)
	}else if function == "getPO" {
		return s.getPO(APIstub, args)
	}
 
	 return shim.Error("Invalid Smart Contract function name.")
 }
 
 
  // This function is initiate by Buyer 
  /*
  PoId			string		`json:"poId"`
	DeliveryDate		string		`json:"deliveryDate"`
	Buyer    string   `json:"buyer"`
	OrderDate		string		`json:"orderDate"`
	seller		string		`json:"seller"`
	Amount			int		`json:"amount"`
	Status			string		`json:"status"`
  */

  func (s *SmartContract) acceptPO(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
 
	poId := args[0];
	POAsBytes, _ := APIstub.GetState(poId)

	var po PurchaseOrder

	err := json.Unmarshal(POAsBytes, &po)

	if err != nil {
		return shim.Error("Issue with PO json unmarshaling")
	}


	PO := PurchaseOrder{PoId: po.PoId, DeliveryDate: po.DeliveryDate, Buyer: po.Buyer, OrderDate: po.OrderDate, Seller: po.Seller, Amount: po.Amount, Status: "Accepted"}
	POBytes, err := json.Marshal(PO)

	if err != nil {
		return shim.Error("Issue with PO json marshaling")
	}

	APIstub.PutState(po.PoId,POBytes)
	fmt.Println("PO Accepted -> ", PO)
	fmt.Println("Request for LC for this PO %v  to Bank -> ",po.PoId)
	
	return shim.Success(nil)
}

  func (s *SmartContract) placeOrder(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
 
	poId := args[0];
	deliveryDate := args[1];
	buyer := args[2];
	orderDate := args[3];
	seller := args[4];
	amount, err := strconv.Atoi(args[5]);
	if err != nil {
		return shim.Error("Not able to parse Amount")
	}


	PO := PurchaseOrder{PoId: poId, DeliveryDate: deliveryDate, Buyer: buyer, OrderDate: orderDate, Seller: seller, Amount: amount, Status: "Requested"}
	POBytes, err := json.Marshal(PO)

	err=APIstub.PutState(poId,POBytes)
	if err!=nil{
		fmt.Errorf("ërro while creating PO data",err.Error())
		return shim.Error(err.Error())
	}
	fmt.Println("PO Requested -> ", PO,poId,POBytes)

	

	return shim.Success(nil)
}
 

 
 // This function is initiate by Buyer 
 func (s *SmartContract) requestLC(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
//func  requestLC(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	 lcId := args[0];
	 expiryDate := args[1];
	 buyer := args[2];
	 bank := args[3];
	 seller := args[4];
	 amount, err := strconv.Atoi(args[5]);
	 poId := args[6];
	 if err != nil {
		 return shim.Error("Not able to parse Amount")
	 }
 
 
	 LC := LetterOfCredit{LCId: lcId, ExpiryDate: expiryDate, Buyer: buyer, Bank: bank, Seller: seller, Amount: amount, Status: "Requested",PoId : poId}
	 LCBytes, err := json.Marshal(LC)
 
	 err=APIstub.PutState(lcId,LCBytes)
	 if err!=nil{
		 fmt.Errorf("ërro while storing data",err.Error())
		 return shim.Error(err.Error())
	 }
	 fmt.Println("LC Requested -> ", LC,lcId,LCBytes)
 
	 
 
	 return shim.Success(nil)
 }
 
 // This function is initiate by Seller
 func (s *SmartContract) issueLC(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
 
	 lcId := args[0];
	 
	 // if err != nil {
	 // 	return shim.Error("No Amount")
	 // }
 
	 LCAsBytes, _ := APIstub.GetState(lcId)
 
	 var lc LetterOfCredit
 
	 err := json.Unmarshal(LCAsBytes, &lc)
 
	 if err != nil {
		 return shim.Error("Issue with LC json unmarshaling")
	 }
 
 
	 LC := LetterOfCredit{LCId: lc.LCId, ExpiryDate: lc.ExpiryDate, Buyer: lc.Buyer, Bank: lc.Bank, Seller: lc.Seller, Amount: lc.Amount, Status: "Issued"}
	 LCBytes, err := json.Marshal(LC)
 
	 if err != nil {
		 return shim.Error("Issue with LC json marshaling")
	 }
 
	 APIstub.PutState(lc.LCId,LCBytes)
	 fmt.Println("LC Issued -> ", LC)
 
 
	 return shim.Success(nil)
 }
 
 func (s *SmartContract) acceptLC(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
 
	 lcId := args[0];
	 
	 
 
	 LCAsBytes, _ := APIstub.GetState(lcId)
 
	 var lc LetterOfCredit
 
	 err := json.Unmarshal(LCAsBytes, &lc)
 
	 if err != nil {
		 return shim.Error("Issue with LC json unmarshaling")
	 }
 
 
	 LC := LetterOfCredit{LCId: lc.LCId, ExpiryDate: lc.ExpiryDate, Buyer: lc.Buyer, Bank: lc.Bank, Seller: lc.Seller, Amount: lc.Amount, Status: "Accepted"}
	 LCBytes, err := json.Marshal(LC)
 
	 if err != nil {
		 return shim.Error("Issue with LC json marshaling")
	 }
 
	 APIstub.PutState(lc.LCId,LCBytes)
	 fmt.Println("LC Accepted -> ", LC)
 
 
	 
 
	 return shim.Success(nil)
 }
 
 func (s *SmartContract) getPO(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
 
	poId := args[0];
	fmt.Println("requested ls value",poId,args[0] )
	
	// if err != nil {
	// 	return shim.Error("No Amount")
	// }

	POAsBytes, err := APIstub.GetState(poId)
	if err!=nil {
		return shim.Error(err.Error())
	}
	fmt.Println("value of the po ",POAsBytes,poId)

	return shim.Success(POAsBytes)
}
 func (s *SmartContract) getLC(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
 
	 lcId := args[0];
	 fmt.Println("requested ls value",lcId,args[0] )
	 
	 // if err != nil {
	 // 	return shim.Error("No Amount")
	 // }
 
	 LCAsBytes, err := APIstub.GetState(lcId)
	 if err!=nil {
		 return shim.Error(err.Error())
	 }
	 fmt.Println("value of the lc ",LCAsBytes,lcId)
 
	 return shim.Success(LCAsBytes)
 }
 
 func (s *SmartContract) getLCHistory(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
 
	 lcId := args[0];
	 
	 
 
	 resultsIterator, err := APIstub.GetHistoryForKey(lcId)
	 if err != nil {
		 return shim.Error("Error retrieving LC history.")
	 }
	 defer resultsIterator.Close()
 
	 // buffer is a JSON array containing historic values for the marble
	 var buffer bytes.Buffer
	 buffer.WriteString("[")
 
	 bArrayMemberAlreadyWritten := false
	 for resultsIterator.HasNext() {
		 response, err := resultsIterator.Next()
		 if err != nil {
			 return shim.Error("Error retrieving LC history.")
		 }
		 // Add a comma before array members, suppress it for the first array member
		 if bArrayMemberAlreadyWritten == true {
			 buffer.WriteString(",")
		 }
		 buffer.WriteString("{\"TxId\":")
		 buffer.WriteString("\"")
		 buffer.WriteString(response.TxId)
		 buffer.WriteString("\"")
 
		 buffer.WriteString(", \"Value\":")
		 // if it was a delete operation on given key, then we need to set the
		 //corresponding value null. Else, we will write the response.Value
		 //as-is (as the Value itself a JSON marble)
		 if response.IsDelete {
			 buffer.WriteString("null")
		 } else {
			 buffer.WriteString(string(response.Value))
		 }
 
		 buffer.WriteString(", \"Timestamp\":")
		 buffer.WriteString("\"")
		 buffer.WriteString(time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).String())
		 buffer.WriteString("\"")
 
		 buffer.WriteString(", \"IsDelete\":")
		 buffer.WriteString("\"")
		 buffer.WriteString(strconv.FormatBool(response.IsDelete))
		 buffer.WriteString("\"")
 
		 buffer.WriteString("}")
		 bArrayMemberAlreadyWritten = true
	 }
	 buffer.WriteString("]")
 
	 fmt.Printf("- getLCHistory returning:\n%s\n", buffer.String())
 
	 
 
	 return shim.Success(buffer.Bytes())
 }
 
 // The main function is only relevant in unit test mode. Only included here for completeness.
 func main() {
 
	 // Create a new Smart Contract
	 err := shim.Start(new(SmartContract))
	 if err != nil {
		 fmt.Printf("Error creating new Smart Contract: %s", err)
	 }
 }