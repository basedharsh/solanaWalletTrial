import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectManager {
  late Web3App wcClient;
  Uri? connectionUri;

  Future<void> initializeWalletConnect() async {
    wcClient = await Web3App.createInstance(
      relayUrl: 'wss://relay.walletconnect.com',
      projectId:
          'a0e1016426165f7c9a0d60c5f158e883', // Replace with your actual project ID
      metadata: PairingMetadata(
        name: 'Your App Name',
        description: 'Your App Description',
        url: 'https://yourapp.com',
        icons: ['https://yourapp.com/icon.png'],
      ),
    );
  }

  Future<void> connectToWallet() async {
    ConnectResponse resp = await wcClient.connect(
      requiredNamespaces: {
        'eip155': RequiredNamespace(
          chains: ['eip155:1'],
          methods: ['eth_sendTransaction'],
          events: ['chainChanged'],
        ),
      },
    );
    connectionUri = resp.uri;

    // Once connected, you can wait for the session data
    final SessionData session = await resp.session.future;
    // Use session data as needed
  }

  // Add methods for sending transactions, handling events, etc.
}
