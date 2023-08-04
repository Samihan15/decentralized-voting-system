import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

const String ethUrl =
    'https://sepolia.infura.io/v3/7cd0595828554464ae5d1fb2ef83ffde';

String? voterPrivateKey;
const contractAddress1 = '0x5Da4c455533bEE0C11fCB1cc65e06E96E37138aE';
final Web3Client ethClient = Web3Client(ethUrl, Client());
