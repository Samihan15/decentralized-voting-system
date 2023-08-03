// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public admin;
    enum Phase {
        Registration,
        Voting,
        Results
    }
    Phase public currentPhase;

    struct Voter {
        string name;
        uint256 adharCardNumber;
        bool isRegistered;
        bool hasVoted;
        bool isAllow; // Flag to check if the voter is allowed to vote
    }

    struct Candidate {
        string name;
        string party;
        uint256 age;
        uint256 voteCount;
    }

    mapping(address => Voter) public voters;
    mapping(address => bool) public isVoterAdded; // Track whether the voter is already added
    Candidate[] public candidates;
    address[] public voterList; // Store list of voters for the admin

    event Registered(address voter);
    event Voted(address voter, uint256 candidateIndex);
    event PhaseChanged(Phase newPhase);
    event AllowVote(address voter, bool isAllowed); // New event to notify when admin allows/disallows voting for a voter

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyRegisteredVoter() {
        require(
            voters[msg.sender].isRegistered,
            "You are not a registered voter"
        );
        _;
    }

    modifier onlyAllowedToVote() {
        require(voters[msg.sender].isAllow, "You are not allowed to vote");
        _;
    }

    modifier onlyInPhase(Phase phase) {
        require(currentPhase == phase, "Invalid phase");
        _;
    }

    constructor() {
        admin = msg.sender;
        currentPhase = Phase.Registration;
    }

    function addCandidate(
        string memory _name,
        string memory _party,
        uint256 _age
    ) public onlyAdmin onlyInPhase(Phase.Registration) {
        candidates.push(Candidate(_name, _party, _age, 0));
    }

    function registerVoter(string memory _name, uint256 _adharCardNumber)
        public
        onlyInPhase(Phase.Registration)
    {
        require(!isVoterAdded[msg.sender], "Voter already registered");
        voters[msg.sender] = Voter(_name, _adharCardNumber, true, false, false); // Initialize isAllow as false initially
        voterList.push(msg.sender); // Add voter to the list for admin's reference
        isVoterAdded[msg.sender] = true;
        emit Registered(msg.sender);
    }

    function changePhase(Phase newPhase) public onlyAdmin {
        currentPhase = newPhase;
        emit PhaseChanged(newPhase);
    }

    function allowVote(address _voter, bool _isAllowed) public onlyAdmin {
        require(voters[_voter].isRegistered, "Voter not registered");
        voters[_voter].isAllow = _isAllowed;
        emit AllowVote(_voter, _isAllowed);
    }

    function vote(uint256 candidateIndex)
        public
        onlyRegisteredVoter
        onlyInPhase(Phase.Voting)
        onlyAllowedToVote
    {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(candidateIndex < candidates.length, "Invalid candidate index");

        voters[msg.sender].hasVoted = true;
        candidates[candidateIndex].voteCount++;

        emit Voted(msg.sender, candidateIndex);
    }

    function getWinner()
        public
        view
        onlyInPhase(Phase.Results)
        returns (string memory winnerName)
    {
        uint256 winningVoteCount = 0;
        uint256 winningCandidateIndex;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateIndex = i;
            }
        }

        winnerName = candidates[winningCandidateIndex].name;
        return winnerName;
    }

    function getVoterList() public view returns (address[] memory) {
        return voterList;
    }

    function getCandidateList() public view returns (Candidate[] memory) {
        return candidates;
    }

    function getCurrentPhase() public view returns (Phase) {
        return currentPhase;
    }

    function updateVoterData(
        address _voter,
        string memory newName,
        uint256 newAdharCardNumber
    ) public onlyAdmin {
        require(voters[_voter].isRegistered, "Voter not registered");
        voters[_voter].name = newName;
        voters[_voter].adharCardNumber = newAdharCardNumber;
    }

    function isVoterAllow(address voterAddress) public view returns(bool){
        return voters[voterAddress].isAllow;
    }
}
