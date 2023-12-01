import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

const String ethUrl =
    'https://sepolia.infura.io/v3/7cd0595828554464ae5d1fb2ef83ffde';

String? voterPrivateKey;
const contractAddress1 = '0xE9Acfb670708b6BCEAe7e665bf0b1D4Dbc7Ecc66';
final Web3Client ethClient = Web3Client(ethUrl, Client());
