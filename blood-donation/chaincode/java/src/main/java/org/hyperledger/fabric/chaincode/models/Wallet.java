package org.hyperledger.fabric.chaincode.models;

public class Wallet {
    private String name;
    private String id;

    public Wallet (String name,  String id) {
        this.name = name;
        this.id = id;
    }

    private Wallet() {}

    public String getName() {
        return name;
    }

    public String getId() {
        return id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setId(String id) {
        this.id = id;
    }
}