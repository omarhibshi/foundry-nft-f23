// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {Test, console} from "forge-std/Test.sol";

contract TestBasicNft is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;
    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testTokenCounter() public {
        uint256 tokenCounter = basicNft.s_tokenCounter();
        assertTrue(tokenCounter == 0);
    }

    function testNameIsCorrect() public {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();

        assertTrue(
            keccak256(bytes(expectedName)) == keccak256(bytes(actualName))
        );
    }

    function testMint() public {
        uint256 initialTokenCount = basicNft.s_tokenCounter();

        string
            memory tokenUri = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

        vm.prank(msg.sender);
        basicNft.minNft(tokenUri);

        uint256 newTokenCounter = basicNft.s_tokenCounter();
        assertTrue(newTokenCounter == initialTokenCount + 1);

        string memory retrievedUri = basicNft.tokenURI(initialTokenCount);
        console.log("retrievedUri : ", retrievedUri);

        assertTrue(
            keccak256(bytes(retrievedUri)) == keccak256(bytes(tokenUri))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.minNft(PUG);
        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(bytes(PUG)) == keccak256(bytes(basicNft.tokenURI(0))));
    }
}
