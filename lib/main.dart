import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _toAddressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late Web3Client _client;
  late String _privateKey;
  late EthereumAddress _contractAddress;
  late DeployedContract _contract;
  late Credentials _credentials;
  BigInt _contractBalance = BigInt.zero;

  double _walletBalance = 0.0;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _privateKey = 'Apni daal bsdke'; // Replace with your private key
    _client = Web3Client(
        'https://sepolia.infura.io/v3/516acf4ef5da4870ad8a82d7b0154e07',
        Client());
    _contractAddress =
        EthereumAddress.fromHex('0xd05251974CBDeBd2276A65dBeF7AA9A73D4Ea961');
    _initContract();
  }

  _initContract() async {
    String abi = await rootBundle.loadString('assets/abi.json');
    _contract = DeployedContract(
        ContractAbi.fromJson(abi, 'SimpleWallet'), _contractAddress);
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> _getContractBalance() async {
    try {
      var balanceFunction = _contract.function('getBalance');
      List<dynamic> result = await _client
          .call(contract: _contract, function: balanceFunction, params: []);
      setState(() {
        _contractBalance = result.first as BigInt;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching contract balance: $e';
      });
    }
  }

  Future<void> _getWalletBalance() async {
    try {
      var walletAddress = await _credentials.extractAddress();
      EtherAmount balanceWei = await _client.getBalance(walletAddress);
      setState(() {
        // Convert Wei to Ether and store it as a double
        _walletBalance = balanceWei.getInWei.toDouble() / 1e18;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching wallet balance: $e';
      });
    }
  }

  Future<void> _sendEther() async {
    try {
      var sendFunction = _contract.function('sendEther');
      double amountInEth = double.parse(_amountController.text);
      BigInt amountInWei =
          BigInt.from((amountInEth * 1e18).toInt()); // Convert to Wei

      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: sendFunction,
          parameters: [
            EthereumAddress.fromHex(_toAddressController.text),
            amountInWei, // Send the amount in Wei
          ],
        ),
      );
    } catch (e) {
      print(e);
      setState(() {
        _errorMessage = 'Error sending Ether: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Simple Wallet')),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Contract Balance: $_contractBalance wei'),
              ElevatedButton(
                onPressed: _getContractBalance,
                child: Text('Get Contract Balance'),
              ),
              Text('Wallet Balance: $_walletBalance wei'),
              ElevatedButton(
                onPressed: _getWalletBalance,
                child: Text('Get Wallet Balance'),
              ),
              TextField(
                controller: _toAddressController,
                decoration:
                    InputDecoration(hintText: 'Enter recipient address'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(hintText: 'Enter amount to send'),
                keyboardType: TextInputType.numberWithOptions(decimal: false),
              ),
              ElevatedButton(
                onPressed: () {
                  _errorMessage = ''; // Clear previous error messages
                  _sendEther();
                },
                child: Text('Send Ether'),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
