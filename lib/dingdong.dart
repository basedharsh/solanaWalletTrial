import 'package:web3modal_flutter/web3modal_flutter.dart';

class Dingdong {
  final _w3mService = W3MService(
    projectId: '{YOUR_PROJECT_ID}',
    metadata: const PairingMetadata(
      name: 'Web3Modal Flutter Example',
      description: 'Web3Modal Flutter Example',
      url: 'https://www.walletconnect.com/',
      icons: ['https://walletconnect.com/walletconnect-logo.png'],
      redirect: Redirect(
        native: 'flutterdapp://',
        universal: 'https://www.walletconnect.com',
      ),
    ),
  );
}
