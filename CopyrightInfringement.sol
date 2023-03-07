pragma solidity ^0.5.0;

// This contract represents a notification and reporting system for copyright infringement incidents.
// It stores information about copyrighted works and potential infringement incidents, and provides
// mechanisms for rights holders to be notified of potential infringement incidents and to take action.

contract CopyrightInfringement {
  // The mapping of work IDs to their metadata (e.g. title, author, etc.)
  mapping (uint => Work) public works;

  // The mapping of incident IDs to their metadata (e.g. work ID, infringing content, etc.)
  mapping (uint => Incident) public incidents;

  // The address of the arbitrator contract
  address public arbitrator;

  // The struct representing a copyrighted work
  struct Work {
    string title;
    string author;
    uint dateCreated;
    address[] rightsHolders;
  }

  // The struct representing a potential infringement incident
  struct Incident {
    uint workId;
    string[] infringingContentUrls;
    address reportedBy;
    bool disputed;
    uint status;
  }

  // The enumeration of incident statuses
  enum Status {
    Pending,
    Investigating,
    Resolved,
    Dismissed
  }

  // The event for when a new work is registered
  event NewWork(uint workId, string title, string author, uint dateCreated);

  // The event for when a new incident is reported
  event NewIncident(
    uint incidentId,
    uint workId,
    string[] infringingContentUrls,
    address reportedBy
  );

  // The event for when an incident is disputed
  event IncidentDisputed(uint incidentId, bool disputed);

  // The event for when the arbitrator address is set
  event ArbitratorSet(address arbitrator);

  // The constructor that sets the arbitrator address
  constructor(address _arbitrator) public {
    arbitrator = _arbitrator;
    emit ArbitratorSet(arbitrator);
  }

  // The function for registering a new copyrighted work
  function registerWork(
    string memory title,
    string memory author,
    uint dateCreated,
    address[] memory rightsHolders
  )
    public
  {
    // Generate a unique ID for the work
    uint workId = keccak256(abi.encodePacked(title, author, dateCreated));

    // Save the work metadata to the mapping
    works[workId] = Work({
      title: title,
      author: author,
      dateCreated: dateCreated,
      rightsHolders: rightsHolders
    });

    // Emit the NewWork event
    emit NewWork(workId, title, author, dateCreated);
  }

  // The function for reporting a potential infringement incident
  function reportIncident(
    uint workId,
    string[] memory infringingContentUrls
  )
    public
  {
    // Generate a unique ID for the incident
    uint incidentId = keccak256(abi.encodePacked(workId, infringingContentUrls));

    // Save the incident metadata to the mapping
    incidents[incidentId] = Incident({
      workId: workId,
      infringingContentUrls,
      reportedBy: msg.sender,
      disputed: false,
      status: Status.Pending
    });

    // Emit the NewIncident event
    emit NewIncident(incidentId, workId, infringingContentUrls, msg.sender);
  }

  // The function for disputing a potential infringement incident
  function disputeIncident(uint incidentId) public {
    // Get the incident from the mapping
    Incident storage incident = incidents[incidentId];

    // Set the disputed flag to true
    incident.disputed = true;

    // Emit the IncidentDisputed event
    emit IncidentDisputed(incidentId, incident.disputed);

    // Call the arbitrator contract to initiate a dispute resolution process
    arbitrator.resolveDispute(incidentId);
  }
}
pragma solidity ^0.5.0;

// This contract represents a peer-to-peer copyright licensing and distribution system.
// It stores information about copyrighted works and their rights holders,
// and provides a mechanism for licensing works and distributing licensing fees among the rights holders.

contract CopyrightLicensing {
  // The mapping of work IDs to their metadata (e.g. title, author, etc.)
  mapping (uint => Work) public works;

  // The mapping of license IDs to their metadata (e.g. work ID, licensee, etc.)
  mapping (uint => License) public licenses;

  // The struct representing a copyrighted work
  struct Work {
    string title;
    string author;
    uint dateCreated;
    address[] rightsHolders;
    uint[] distribution;
  }

  // The struct representing a license to use a copyrighted work
  struct License {
    uint workId;
    address licensee;
    uint amountPaid;
  }

  // The event for when a new work is registered
  event NewWork(uint workId, string title, string author, uint dateCreated);

  // The event for when a new license is issued
  event NewLicense(uint licenseId, uint workId, address licensee, uint amountPaid);

// The function for registering a new copyrighted work
  function registerWork(
    string memory title,
    string memory author,
    uint dateCreated,
    address[] memory rightsHolders,
    uint[] memory distribution
  )
    public
  {
    // Generate a unique ID for the work using sha256
    uint workId = sha256(abi.encodePacked(title, author, dateCreated));

    // Save the work metadata to the mapping
    works[workId] = Work({
      title: title,
      author: author,
      dateCreated: dateCreated,
      rightsHolders: rightsHolders,
      distribution: distribution
    });

    // Emit the NewWork event
    emit NewWork(workId, title, author, dateCreated);
  }

  // The function for issuing a license to use a copyrighted work
  function issueLicense(uint workId, uint amount) public payable {
    // Generate a unique ID for the license using sha256
    uint licenseId = sha256(abi.encodePacked(workId, msg.sender, amount));

    // Save the license metadata to the mapping
    licenses[licenseId] = License({
      workId: workId,
      licensee: msg.sender,
      amountPaid: amount
    });

    // Get the work from the mapping
    Work storage work = works[workId];

    // Calculate the total distribution amount
    uint totalDistribution = 0;
    for (uint i = 0; i < work.distribution.length; i++) {
      totalDistribution += work.distribution[i];
    }

    // Iterate over the rights holders and distribute the licensing fees among them
    for (uint i = 0; i < work.rightsHolders.length; i++) {
      // Calculate the amount to distribute to this rights holder
      uint feeAmount = (amount * work.distribution[i]) / totalDistribution;

      // Send the fee amount to the rights holder
      work.rightsHolders[i].transfer(feeAmount);
    }

    // Emit the NewLicense event
    emit NewLicense(licenseId, workId, msg.sender, amount);
  }
}
