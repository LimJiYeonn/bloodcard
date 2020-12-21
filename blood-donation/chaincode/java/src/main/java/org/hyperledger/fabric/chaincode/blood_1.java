package org.hyperledger.fabric.chaincode;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.protobuf.ByteString;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperledger.fabric.chaincode.models.Wallet;
import org.hyperledger.fabric.shim.Chaincode;
import org.hyperledger.fabric.shim.ChaincodeBase;
import org.hyperledger.fabric.shim.ChaincodeStub;
import org.hyperledger.fabric.shim.ledger.KeyValue;
//import org.hyperledger.fabric.shim.QueryResultsIterator;



import java.util.List;

import static java.nio.charset.StandardCharsets.UTF_8;
import static org.hyperledger.fabric.shim.ResponseUtils.newErrorResponse;
import static org.hyperledger.fabric.shim.ResponseUtils.newSuccessResponse;

public class blood_1 extends ChaincodeBase{

//    private static Log _logger = LogFactory.getLog(basicchaincode.class);

    @Override
    public Chaincode.Response init(ChaincodeStub stub) {
        try {
            List<String> args = stub.getStringArgs();
            if (args.size() != 2) {
                newErrorResponse("Error Incorrect arguemnts");
            }
            stub.putStringState(args.get(0), args.get(1));
            return newSuccessResponse();
        } catch (Throwable e) {
            return newErrorResponse("Failed to create asset");
        }
    }

    @Override
    public Response invoke(ChaincodeStub stub) {
        try {
            String func = stub.getFunction();
            List<String> params = stub.getParameters();

            if(func.equals("initWallet")) {
                return initWallet(stub);
            } else if (func.equals("getWallet")) {
                return getWallet(stub, params);
            }
            return newErrorResponse("Invalid invoke function name");
        } catch(Throwable e) {
            return newErrorResponse(e.getMessage());
        }

    }

    public static void main(String[] args) {
        new blood_1().start(args);
    }

    private Response initWallet(ChaincodeStub stub) {
        Wallet wallet1 = new Wallet("Hyper", "1");
        Wallet wallet2 = new Wallet("Ledger", "2");
        GsonBuilder builder = new GsonBuilder();
        Gson gson = builder.create();

        try {
            stub.putState("Hyper", gson.toJson(wallet1).getBytes());
            stub.putState("Ledger", gson.toJson(wallet2).getBytes());
            return newSuccessResponse("Wallet created");
        } catch (Throwable e) {
            return newErrorResponse(e.getMessage());
        }
    }
}


//public class blood_1 {
//}
