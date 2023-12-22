const CarbonFootprintTracking = artifacts.require("CarbonFootprintTracking");

contract("CarbonFootprintTracking", function (accounts) {
  it("should register a farmer", async function () {
    const contractInstance = await CarbonFootprintTracking.deployed();

    // Replace with actual farmer details
    const farmerName = "John Doe";
    const farmerLocation = "Farmville";

    // Perform farmer registration
    await contractInstance.registerFarmer(farmerName, farmerLocation);

    // Retrieve and verify farmer information
    const [name, location, totalCarbonReduction] = await contractInstance.getFarmerInfo(accounts[0]);
    assert.equal(name, farmerName, "Incorrect farmer name");
    assert.equal(location, farmerLocation, "Incorrect farmer location");
    assert.equal(totalCarbonReduction, 0, "Total carbon reduction should be zero initially");
  });
});
