// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract voting{

    address public contractOwner;

    address[] public candidatesList;

    mapping (address => uint8) public votesRecieved;

    address public winner;
    uint public winnerVotes;

    enum votingStatus {NotStarted, Running, Completed}
    votingStatus public status;

    constructor() {
        contractOwner = msg.sender;
    }

    modifier OnlyOnwer{
        if(msg.sender == contractOwner){
            _;
        }
    }

    function setStatus() OnlyOnwer public{
        if(status != votingStatus.Completed){
            status = votingStatus.Running;
        }else{
            status = votingStatus.Completed;
        }
    }
    
    function registerCandidates(address _candidate) OnlyOnwer public{
        candidatesList.push(_candidate);
    }

    function vote(address _candidate) public{
        require(validadeCandidate(_candidate), "Candidate not valid!!!");
        assert(status == votingStatus.Running);
        votesRecieved[_candidate] += 1;
    }

    function validadeCandidate(address _candidate) view public returns(bool){

        for(uint i = 0; i < candidatesList.length; i++){
            if(candidatesList[i] == _candidate){
                return true;
            }
        }
        return false;
    }

    function votesCount(address _candidate) public view returns(uint){
        require(validadeCandidate(_candidate), "Candidate not valid!!!");
        assert(status == votingStatus.Running);
        return votesRecieved[_candidate];
    }

    function result() public{
        require(status == votingStatus.Completed, "Voting is not completed!!!");
        for(uint i = 0; i < candidatesList.length; i++){
            if(votesRecieved[candidatesList[i]] > winnerVotes){
                winnerVotes = votesRecieved[candidatesList[i]];
                winner = candidatesList[i];
            }
        }
    }



}