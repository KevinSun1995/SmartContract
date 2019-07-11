/**
 * The Celebrity contract does this and that...
 */
contract Celebrity {
	uint public bidEndTime;

	address public lowestBidder;
	uint public lowestBid;

	address[] public thirdPartyList;
	address public thirdParty;

	string public demanding;
	address public creator;
	mapping (address => uint) patientialBidder;

	bool hasContrator;
	bool ended;
	
	event LowestBidFound(address bidder, uint amount, address thirdParty);
	event BiddingEnd(address winner, uint amount, address thirdParty);

	constructor(uint _biddingTime, address[] _thirdPartyList, string _demanding) public{
		bidEndTime = now + _biddingTime;
		thirdPartyList = _thirdPartyList;
		demanding = _demanding;
		creator = msg.sender;
	}

	function bid(address _thridPartyList) public{
		
		require (
			now <= bidEndTime,
			"Bid already ended!"
		);
		require (
			msg.value < lowestBid,
			"There already is a lower bid."
		);
		bool flag = false;
		address tempThirdParty;
		for(uint i = 0; i < thirdPartyList.length; i++){
			for(uint j= 0; j < _thirdPartyList.length; j++){
				if(thirdPartyList[i] == _thirdPartyList[j]){
					flag = true;
					tempThirdParty = thirdPartyList[i];
					break;
				}
			}
			if(flag) break;
		}


		require (flag, "Do not share trusted third party");
		
		hasContrator = true;
		lowestBidder = msg.sender;
		lowestBid = msg.value;
		thirdParty = tempThirdParty;
		patientialBidder[lowestBidder] = lowestBid;
		emit LowestBidFound(msg.sender, msg.value, thirdParty);
	}

	function BidEnd() public{


		require (now >= bidEndTime, "Bid Not End");
		
		require (!ended, 'bid has already ended');

		ended = true;
		emit BiddingEnd(lowestBidder, lowestBid, thirdParty);
	}

	function beginContract(uint totalAmount) internal{

		require (ended, "Bid has not ended yet");

		require (hasContrator, "Nobody wants to work for you");

		thirdParty.send(totalAmount);	
	}
	
	function infoView () public returns(address c, address w, uint amount, string d){
		c = creator;
		w = lowestBidder;
		a = amount;
		d = demanding;
	}
}




/**
 * The thirdParty contract does this and that...
 */
contract thirdParty {
	mapping (address => uint) deposits;
	uint feeRate;
	address public celebrity;
	address public worker;
	address public creator;
	uint public amount;
	string demanding;
	bool hasDeposited;
	bool hasChecked;
	bool status;
	
	constructor thirdParty (address _celebrity, address _worker, uint _amount, string _demanding) public{
		celebrity = _celebrity;
		worker = _worker;
		amount = _amount;
		demanding = _demanding;
		feeRate = 0.05;
		creator = msg.sender;

	}

	function deposit () public payable {
		require (msg.sender == celebrity);

		require (msg.value >= amount * (1+feeRate)）;

		deposits[worker] == amount;

		hasDeposited = true;
	}
	
	function withdraw() public returns(bool){


		require (msg.sender == worker);

		require (hasChecked);

		require (status);
		
		unit amount = deposits[msg.sender];
		if(amount > 0){
			deposits[msg.sender] = 0;

			if(!msg.sender.sender(amount)){
				deposits[msg.sender] = amount
				return false;			}
		}
		return true;
	}

	function feeView() public returns(uint rate){
		rate = feeRate;
	}
	
	function check (bool result){

		require (msg.sender == creator);
		
		status = result;
		hasChecked = true;
	}
	

}





















