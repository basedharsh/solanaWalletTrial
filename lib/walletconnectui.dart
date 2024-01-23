import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:solidity_wallet/walletconnect.dart';

class WalletConnectPage extends StatefulWidget {
  @override
  _WalletConnectPageState createState() => _WalletConnectPageState();
}

class _WalletConnectPageState extends State<WalletConnectPage> {
  final WalletConnectManager _walletConnectManager = WalletConnectManager();

  @override
  void initState() {
    super.initState();
    _walletConnectManager.initializeWalletConnect();
  }

  void _connectToWallet() async {
    await _walletConnectManager.connectToWallet();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WalletConnect with MetaMask')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _connectToWallet,
              child: Text('Connect to Wallet'),
            ),
            _walletConnectManager.connectionUri != null
                ? QrImageView(
                    data: _walletConnectManager.connectionUri!.toString())
                : Container(), // Empty container as a placeholder
            // Add more UI elements for transactions and event handling
          ],
        ),
      ),
    );
  }

//   Widget _renderQrImage() {
//   if (_walletConnectManager.connectionUri != null) {
//     return QrImage(data: _walletConnectManager.connectionUri!.toString());
//   } else {
//     return Container(); // Return an empty container when there's no URI
//   }
// }
}
