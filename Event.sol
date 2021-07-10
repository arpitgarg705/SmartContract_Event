pragma solidity ^0.5.9;
contract Event {

    enum Category {Dance, Music, Paint}
    // categories of artists
    
    struct Artist {
        address addr;
        Category category;
        uint quote;
        uint timestamp;
       // artist details;
    }
    
    struct Venue {
        address addr;
        uint quote;
        uint area;
        uint timestamp;
       // venue details;
    }
    
    struct Sponsor {
        address addr;
        uint quote;
        uint timestamp;
       // sponsor details;
    }
    
    struct PublicityManager {
        address addr;
        uint quote;
        uint timestamp;
       // publicity manager details;
    }
    
    struct Participant {
        address addr;
        uint8 count;
        uint timestamp;
       // participants details;
    }

    address eventHead;
    string location;
    string eventName; 
    string eventDescription;
    uint8 fees;
    uint8 maxAllowed;
    uint8 artistsNum;
    
    mapping(address => Artist) artists;
    mapping(address => Venue) venues;
    mapping(address => Sponsor) sponsors;
    mapping(address => PublicityManager) publicitymanagers;
    mapping(address => Participant) participants;
    
    address[] artistsArr;
    address[] sponsorsArr;
    address venue;
    address publicitymanager;
    uint artistsArrCnt;
    uint sponsorsArrCnt;
    uint participantCnt;

    /// Create a new eevnt with its details.
    constructor(string memory _eventName, string memory _eventDescription, string memory _location, uint8 _fees, uint8 _maxAllowed, uint8 _artistsNum, uint8 _sponsorsNum) public {
        eventHead = msg.sender;
        eventName = _eventName;
        eventDescription = _eventDescription;
        location = _location;
        fees = _fees;
        maxAllowed = _maxAllowed;
        artistsNum = _artistsNum;
        artistsArr.length = _artistsNum;
        sponsorsArr.length = _sponsorsNum;
        
    }

    
    // Registration modifier
    modifier validRegistration()
    { require(artists[msg.sender].timestamp == 0 && venues[msg.sender].timestamp == 0 && sponsors[msg.sender].timestamp == 0 && publicitymanagers[msg.sender].timestamp == 0 && participants[msg.sender].timestamp == 0);
      _;
    }
    
    // participant count modifier
    modifier validCount(uint8 _count)
    { require((participantCnt+_count) <= maxAllowed);
      _;
    }
    
    // Selection modifier
    modifier validSelection(address _addr)
    { require(msg.sender == eventHead && (artists[_addr].timestamp != 0 || venues[_addr].timestamp != 0 || sponsors[_addr].timestamp != 0 || publicitymanagers[_addr].timestamp != 0 || participants[_addr].timestamp == 0) && (artistsArr.length>=artistsArrCnt) && (sponsorsArr.length>=sponsorsArrCnt));
      _;
    }
    
    
    event artistReg(address _addr, Category _category, uint _quote);
    /// let an artist register.
    function artistRegister(Category _category, uint _quote) public validRegistration() {
        //if (artists[msg.sender].timestamp != 0) return;
        
        artists[msg.sender].category = _category;
        artists[msg.sender].quote = _quote;
        artists[msg.sender].timestamp = now;
        
        emit artistReg(msg.sender, _category, _quote);
    }
    
    event venueReg(address _addr, uint _area, uint _quote);
    /// let a venue register.
    function venueRegister(uint _area, uint _quote) public validRegistration() {
        //if (venues[msg.sender].timestamp != 0) return;
        
        venues[msg.sender].area = _area;
        venues[msg.sender].quote = _quote;
        venues[msg.sender].timestamp = now;
        
        emit venueReg(msg.sender, _area, _quote);
    }
    
    event sponsorReg(address _addr, uint _quote);
    /// let a sponsor register.
    function sponsorRegister(uint _quote) public validRegistration() {
        //if (sponsors[msg.sender].timestamp != 0) return;
        
        sponsors[msg.sender].quote = _quote;
        sponsors[msg.sender].timestamp = now;
        
        emit sponsorReg(msg.sender, _quote);
    }
    
    event publicitymanagerReg(address _addr, uint _quote);
    /// let a publicity manager register.
    function publicitymanagerRegister(uint _quote) public validRegistration() {
        //if (publicitymanagers[msg.sender].timestamp != 0) return;
        
        publicitymanagers[msg.sender].quote = _quote;
        publicitymanagers[msg.sender].timestamp = now;
        
        emit publicitymanagerReg(msg.sender, _quote);
    }
    
    event participantReg(address _addr, uint8 _count);
    /// let a participant register.
    function participantRegister(uint8 _count) public validRegistration() validCount(_count){
        //if (participants[msg.sender].timestamp != 0) return;
        
        participants[msg.sender].count = _count;
        participants[msg.sender].timestamp = now;
        participantCnt += _count;
        
        emit participantReg(msg.sender, _count);
    }
    
    /// Select a registered artist.
    function selectArtist(address _addr) public validSelection(_addr) {
        //if (msg.sender == eventHead && artists[_addr].timestamp == 0) return;
        
        artistsArr[artistsArrCnt] = _addr;
        artistsArrCnt = artistsArrCnt+1;
    }
    
    /// Select a registered sponsor.
    function selectSponsor(address _addr) public validSelection(_addr) {
        sponsorsArr[sponsorsArrCnt] = _addr;
        sponsorsArrCnt = sponsorsArrCnt+1;
    }
    
    /// Select a registered venue.
    function selectVenue(address _addr) public validSelection(_addr) {
        venue = _addr;
    }
    
    /// Select a registered publicity manager.
    function selectPublicitymanager(address _addr) public validSelection(_addr) {
        publicitymanager = _addr;
    }

}
 
