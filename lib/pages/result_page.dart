import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:voting_dapp/widgets/drawer.dart';

import '../utils/constants.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ConfettiController _confettiController = ConfettiController();
  String phase = '0';
  String? winner;
  List<Map<String, dynamic>> candidates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentPhaseData();
  }

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
  }

  Future<void> getCurrentPhaseData() async {
    String currentPhase = await getCurrentPhase(ethClient);
    setState(() {
      phase = currentPhase;
    });
    if (phase == '2') {
      _confettiController.play();
      fetchWinnerAndCandidates();
    }
  }

  Future<void> fetchWinnerAndCandidates() async {
    try {
      Map<String, dynamic>? result = await getWinner(ethClient);
      if (result != null) {
        setState(() {
          winner = result['winner'];
          candidates = result['candidates'];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching winner and candidates: $e");
      setState(() {
        winner = "Unknown";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Scaffold(
        appBar: AppBar(
          title: const Text("Election Result"),
        ),
        body: phase == '2'
            ? RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 3));
                  await getCurrentPhase(ethClient);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          children: [
                            const Text(
                              "👑👑Winner👑👑",
                              style: TextStyle(
                                  fontSize: 35, fontStyle: FontStyle.italic),
                            ),
                            Text(
                              isLoading ? 'Loading...' : winner ?? "N/A",
                              style: const TextStyle(
                                  fontSize: 25, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: candidates.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> candidateData =
                                      candidates.isNotEmpty
                                          ? candidates[index]
                                          : {};
                                  String name = candidateData['name'] ?? "N/A";
                                  String party =
                                      candidateData['party'] ?? "N/A";
                                  int age = candidateData['age'].toInt() ?? 0;
                                  int voteCount =
                                      candidateData['voteCount'].toInt() ?? 0;

                                  return ListTile(
                                    style: ListTileStyle.list,
                                    title: Text(
                                      "Candidate Name: $name",
                                      style: const TextStyle(fontSize: 19),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Votes: $voteCount"),
                                        Text("Party: $party")
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  await getCurrentPhase(ethClient);
                },
                child: ListView(children: const [
                  Center(
                    child: Text(
                      'Result is not published yet',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ]),
              ),
        drawer: const MyDrawer(),
      ),
      ConfettiWidget(
        confettiController: _confettiController,
        blastDirection: pi / 2,
        emissionFrequency: 0.02,
      )
    ]);
  }
}
