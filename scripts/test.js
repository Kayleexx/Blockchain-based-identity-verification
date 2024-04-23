const { expect } = require("chai");

describe("IdentityVerificationSystem", function () {
  let IdentityVerificationSystem;
  let identityVerificationSystem;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
    IdentityVerificationSystem = await ethers.getContractFactory("IdentityVerificationSystem");
    identityVerificationSystem = await IdentityVerificationSystem.deploy();
    await identityVerificationSystem.deployed();
  });

  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      expect(await identityVerificationSystem.admin()).to.equal(owner.address);
    });

    it("Should set the userIdCounter to 1", async function () {
      expect(await identityVerificationSystem.userIdCounter()).to.equal(1);
    });
  });

  describe("Authorization", function () {
    it("Should authorize a user", async function () {
      await identityVerificationSystem.authorizeUser(addr1.address);
      expect(await identityVerificationSystem.users(addr1.address)).to.be.an("object");
    });

    it("Should not authorize the same user twice", async function () {
      await identityVerificationSystem.authorizeUser(addr1.address);
      await expect(identityVerificationSystem.authorizeUser(addr1.address)).to.be.revertedWith("User is already authorized");
    });

    it("Should not authorize a user if not called by the admin", async function () {
      await expect(identityVerificationSystem.connect(addr1).authorizeUser(addr1.address)).to.be.revertedWith("Only admin can call this function");
    });
  });

  
});
