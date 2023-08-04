import 'package:flutter/material.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:voting_dapp/widgets/drawer.dart';
import 'package:voting_dapp/widgets/snackbar.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({Key? key}) : super(key: key);

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  List<Map<String, dynamic>> candidates = [];
  String phase = '0';

  @override
  void initState() {
    super.initState();
    getCurrentPhaseData();
    getCandidatesData();
  }

  Future<void> getCandidatesData() async {
    List<Map<String, dynamic>> candidatesList = await getCandidateList();
    setState(() {
      candidates = candidatesList;
    });
  }

  Future<void> getCurrentPhaseData() async {
    String currentPhase = await getCurrentPhase(ethClient);
    setState(() {
      phase = currentPhase;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voting Page")),
      body: phase == '1'
          ? candidates.isEmpty // Check if candidates list is empty
              ? const Center(
                  child:
                      CircularProgressIndicator(), // Show a loading indicator
                )
              : ListView.builder(
                  itemCount: candidates.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> candidateData = candidates[index];
                    if (candidateData.length >= 4) {
                      String name = candidateData['name'];
                      String party = candidateData['party'];
                      int age = candidateData['age'].toInt();

                      return Card(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Candidate Name: $name",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Age: $age",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Party: $party",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Center(
                                child: SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final response =
                                          await vote(ethClient, index);
                                      if (response == 'null') {
                                        showSnackBar(
                                            context, 'You already voted');
                                      } else {
                                        showSnackBar(
                                            context, 'Vote count successfuly');
                                      }
                                    },
                                    child: const Text(
                                      "Vote",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                )
          : const Center(
              child: Text(
                'This is not a voting phase.',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
      drawer: const MyDrawer(),
    );
  }
}
