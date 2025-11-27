// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainVotingSystem {
    // Struct to represent a candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    address public owner; // Owner of the contract
    mapping(address => bool) public voters; // Mapping to check if an address has voted
    mapping(uint => Candidate) public candidates; // Mapping to store candidates
    uint public candidatesCount;
    uint public totalVotes;

    // Events
    event Voted(address indexed voter, uint indexed candidateId);
    event NewCandidate(uint indexed candidateId, string name);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted.");
        _;
    }

    constructor() {
        owner = msg.sender;
        candidatesCount = 0;
        totalVotes = 0;
    }

    // Function to add a new candidate
    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit NewCandidate(candidatesCount, _name);
    }

    // Function for users to vote
    function vote(uint _candidateId) public hasNotVoted {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");
        candidates[_candidateId].voteCount++;
        totalVotes++;
        voters[msg.sender] = true;
        emit Voted(msg.sender, _candidateId);
    }

    // Function to get the vote count for a candidate
    function getVoteCount(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");
        return candidates[_candidateId].voteCount;
    }

    // Function to get the total number of votes
    function getTotalVotes() public view returns (uint) {
        return totalVotes;
    }
}

