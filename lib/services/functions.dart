import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import '../utils/constants.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String?> callFunction(Web3Client ethClient, String privateKey,
    String funcname, List<dynamic> args) async {
  final contract = await loadContract();

  final credentials = EthPrivateKey.fromHex(privateKey);
  final ethFunction = contract.function(funcname);

  try {
    final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true,
    );

    return result;
  } catch (e) {
    // Handle the error, you can log, show a message, etc.
    print("Error calling function: $e");
    return null; // Return null or throw an exception based on your requirement
  }
}

Future<void> registerVoter(
    Web3Client ethClient, String name, int aadhar) async {
  final ethFunction = 'registerVoter';
  final args = [name, BigInt.from(aadhar)];
  await callFunction(ethClient, voterPrivateKey!, ethFunction, args);
}

Future<String> vote(Web3Client ethClient, int index) async {
  final ethFunction = 'vote';
  final args = [BigInt.from(index)];
  final result =
      await callFunction(ethClient, voterPrivateKey!, ethFunction, args);
  return result.toString();
}

Future<Map<String, dynamic>> getWinner(Web3Client ethClient) async {
  final ethFunction = 'getWinner';
  final result = await ask(
    ethFunction,
    [],
    ethClient,
  );

  final candidates = await getCandidateList();

  // Add null checks or use null-aware operators
  final winnerName = result[0]?.toString() ??
      "Unknown"; // Use "Unknown" as default value if result is null
  final validCandidates = candidates ??
      []; // Use an empty list as default value if candidates is null

  return {
    'winner': winnerName,
    'candidates': validCandidates,
  };
}

Future<String> getCurrentPhase(Web3Client ethClient) async {
  final ethFunction = 'getCurrentPhase';
  final result = await ask(ethFunction, [], ethClient);
  print(result);
  return result[0].toString();
}

Future<bool?> isVoterAllow(
    Web3Client ethClient, EthereumAddress voterAddress) async {
  final contract = await loadContract();
  final ethFunction = contract.function('isVoterAllow');
  final List<dynamic> args = [voterAddress];

  final result = await ethClient.call(
      contract: contract, function: ethFunction, params: args);

  // Process the result here
  if (result == null || result.isEmpty) {
    return null; // or handle the null case appropriately based on your app's logic
  }

  bool isAllowed = result[0] as bool;
  return isAllowed;
}

Future<List<Map<String, dynamic>>> getCandidateList() async {
  final ethFunction = 'getCandidateList';
  List<dynamic> result = await ask(ethFunction, [], ethClient);

  print(result);

  if (result == null || result.isEmpty) {
    return [];
  }

  List<Map<String, dynamic>> candidates = [];
  if (result is List<dynamic> && result.isNotEmpty) {
    List<dynamic> candidatesData = result[0];
    for (var candidateDataList in candidatesData) {
      if (candidateDataList is List<dynamic> && candidateDataList.length >= 4) {
        Map<String, dynamic> candidate = {
          'name': candidateDataList[0].toString(), // Convert BigInt to String
          'party': candidateDataList[1].toString(), // Convert BigInt to String
          'age': BigInt.parse(
              candidateDataList[2].toString()), // Convert String to BigInt
          'voteCount': BigInt.parse(
              candidateDataList[3].toString()), // Convert String to BigInt
        };
        candidates.add(candidate);
      }
    }
  }
  print(candidates);
  return candidates;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}


// Future<List<Candidate>> getCandidateList() async {
//   final ethFunction = contract.function('getCandidateList');

//   final result =
//       await ethClient.call(contract: contract, function: ethFunction);

//   if (result == null || result.isEmpty) {
//     return []; // or handle the empty case appropriately based on your app's logic
//   }

//   List<Candidate> candidates = [];
//   for (var candidateData in result[0]) {
//     Candidate candidate = Candidate(
//       name: candidateData[0] as String,
//       party: candidateData[1] as String,
//       age: candidateData[2] as BigInt, // or int, depending on your contract
//       voteCount:
//           candidateData[3] as BigInt, // or int, depending on your contract
//     );
//     candidates.add(candidate);
//   }

//   return candidates;
// }

// Future<void> addCandidate(
//     Web3Client ethClient, String name, String party, int age) async {
//   final ethFunction = "addCandidate";
//   final args = [name, party, age];
//   await callFunction(ethClient, ownersPrivateKey, ethFunction, args);
// }

// Future<void> registerVoter(
//     Web3Client ethClient, String name, int adharCardNumber) async {
//   final ethFunction = "registerVoter";
//   final args = [name, adharCardNumber];
//   await callFunction(ethClient, ownersPrivateKey, ethFunction, args);
// }

// Future<void> changePhase(Web3Client ethClient, String newPhase) async {
//   final ethFunction = "changePhase";
//   final args = [newPhase];
//   await callFunction(ethClient, ownersPrivateKey, ethFunction, args);
// }

// Future<void> allowVote(
//     Web3Client ethClient, String voterAddress, bool isAllowed) async {
//   final ethFunction = "allowVote";
//   final args = [EthereumAddress.fromHex(voterAddress), isAllowed];
//   await callFunction(ethClient, ownersPrivateKey, ethFunction, args);
// }

// Future<void> vote(Web3Client ethClient, int candidateIndex) async {
//   final ethFunction = "vote";
//   final args = [BigInt.from(candidateIndex)];
//   await callFunction(ethClient, voterPrivateKey!, ethFunction, args);
// }

// Future<List?> getVoterList(Web3Client ethClient) async {
//   final contract = await loadContract();

//   final ethFunction = contract.function("getVoterList");
//   try {
//     final result = await ethClient.call(
//       contract: contract,
//       function: ethFunction,
//       params: [],
//     );

//     return result;
//   } catch (e) {
//     // Handle the error, you can log, show a message, etc.
//     print("Error getting voter list: $e");
//     return null; // Return null or throw an exception based on your requirement
//   }
// }

// Future<List?> getCandidateList(Web3Client ethClient) async {
//   final contract = await loadContract();

//   final ethFunction = contract.function("getCandidateList");
//   try {
//     final result = await ethClient.call(
//       contract: contract,
//       function: ethFunction,
//       params: [],
//     );

//     return result;
//   } catch (e) {
//     // Handle the error, you can log, show a message, etc.
//     print("Error getting candidate list: $e");
//     return null; // Return null or throw an exception based on your requirement
//   }
// }

// Future<String?> getCurrentPhase(Web3Client ethClient) async {
//   final contract = await loadContract();
//   final ethFunction = contract.function("getCurrentPhase");

//   try {
//     final result = await ethClient.call(
//       contract: contract,
//       function: ethFunction,
//       params: [],
//     );

//     return result[0].toString();
//   } catch (e) {
//     // Handle the error, you can log, show a message, etc.
//     print("Error getting current phase: $e");
//     return null; // Return null or throw an exception based on your requirement
//   }
// }