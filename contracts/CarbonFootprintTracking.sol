// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CarbonFootprintTracking {
    address public owner;

    // Struct to represent sustainable practices
    struct SustainablePractice {
        string practiceName;
        uint256 carbonReduction; // in kilograms
        uint256 timestamp;
    }

    // Struct to represent farmer information
    struct Farmer {
        string name;
        string location;
        uint256 totalCarbonReduction; // Total carbon reduction achieved by the farmer
        SustainablePractice[] practices; // Array to store sustainable practices
    }

    // Mapping to store farmer information
    mapping(address => Farmer) public farmers;

    // Event to log each time a farmer adds a sustainable practice
    event SustainablePracticeAdded(
        address indexed farmer,
        string practiceName,
        uint256 carbonReduction,
        uint256 timestamp
    );

    // Event to log each time a farmer's information is updated
    event FarmerUpdated(address indexed farmer, string name, string location);

    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure only the contract owner can perform certain actions
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    // Function for farmers to register/update their information
    function registerFarmer(
        string memory _name,
        string memory _location
    ) external {
        Farmer storage farmer = farmers[msg.sender];

        farmer.name = _name;
        farmer.location = _location;

        // Emit an event to log the farmer's information update
        emit FarmerUpdated(msg.sender, _name, _location);
    }

    // Function for farmers to add sustainable practices
    function addSustainablePractice(
        string memory _practiceName,
        uint256 _carbonReduction
    ) external {
        require(
            _carbonReduction > 0,
            "Carbon reduction must be greater than zero"
        );

        Farmer storage farmer = farmers[msg.sender];

        SustainablePractice memory newPractice = SustainablePractice({
            practiceName: _practiceName,
            carbonReduction: _carbonReduction,
            timestamp: block.timestamp
        });

        farmer.practices.push(newPractice);
        farmer.totalCarbonReduction += _carbonReduction;

        // Emit an event to log the addition of a sustainable practice
        emit SustainablePracticeAdded(
            msg.sender,
            _practiceName,
            _carbonReduction,
            block.timestamp
        );
    }

    // Function to get the farmer's information
    function getFarmerInfo(
        address _farmer
    ) external view returns (string memory, string memory, uint256) {
        Farmer storage farmer = farmers[_farmer];
        return (farmer.name, farmer.location, farmer.totalCarbonReduction);
    }

    // Function to get the latest sustainable practice for a specific farmer
    function getLatestSustainablePractice(
        address _farmer
    ) external view returns (string memory, uint256, uint256) {
        Farmer storage farmer = farmers[_farmer];

        require(
            farmer.practices.length > 0,
            "No sustainable practices recorded"
        );

        SustainablePractice storage latestPractice = farmer.practices[
            farmer.practices.length - 1
        ];

        return (
            latestPractice.practiceName,
            latestPractice.carbonReduction,
            latestPractice.timestamp
        );
    }

    // Function to Get Total Sustainable Practices:
    function getTotalSustainablePractices(
        address _farmer
    ) external view returns (uint256) {
        Farmer storage farmer = farmers[_farmer];
        return farmer.practices.length;
    }

    // Function to Get All Sustainable Practices
    function getAllSustainablePractices(
        address _farmer
    ) external view returns (SustainablePractice[] memory) {
        Farmer storage farmer = farmers[_farmer];
        return farmer.practices;
    }

    // Function to Calculate Average Carbon Reduction
    function getAverageCarbonReduction(
        address _farmer
    ) external view returns (uint256) {
        Farmer storage farmer = farmers[_farmer];
        if (farmer.practices.length == 0) {
            return 0;
        }

        return farmer.totalCarbonReduction / farmer.practices.length;
    }

    // Function to Check if Farmer Exists
    function isFarmerRegistered(address _farmer) external view returns (bool) {
        return bytes(farmers[_farmer].name).length > 0;
    }

    // Function to Transfer Ownership
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid new owner address");
        owner = _newOwner;
    }

    // Function to Withdraw Funds:
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
