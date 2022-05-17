//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// Contract already deployed to Ropsten, address:
// 0xD6e74bce3C3565d477caDDb3448B60c8F7C72c36

contract StorageTest {
    // These slot numbers are actually 32 byte hex strings, for simplicity I've ommited this detail.
    // i.e. actualAddress = ethers.utils.zeroPad(slotNumber, 32);
    uint256    public a = 1;                                          // Slot 0
    uint256[2] public b = [2, 3];                                     // Slot 1, 2
    uint16     public c = 4;                                          // Slot 3
    uint32     public d = 5;                                          // Slot 3
    uint16     public e = 6;                                          // Slot 3
    address    public f = 0xb14b06B096cCfB7B91f72bD95BD148AdA9113dBc; // Slot 3
    uint256    public g = 8;                                          // Slot 4
    uint256[]  public h;                                              // Slot 5 - will contain length of array, 3
    uint256    public i = 9;                                          // Slot 6
    mapping(uint256 => uint256) public j;                             // Slot 7 - will contain 0, mappings have no length
    mapping(address => uint256) public k;                             // Slot 8 - will contain 0, mappings have no length
                                              
    constructor() {
        // The first element of a dynamic array is located at `address = keccak256(ethers.utils.zeroPad(arraySlotNumber, 32));`
        // firstElementSlotAddress = ethers.utils.keccak256(ethers.utils.zeroPad(5, 32));
        h.push(10); // Slot firstElementSlotAddress     (e.g. deployed contract: 0x036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0)
        h.push(11); // Slot firstElementSlotAddress + 1 (e.g. deployed contract: 0x036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db1)
        h.push(12); // Slot firstElementSlotAddress + 2 (e.g. deployed contract: 0x036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db2)

        // For mappings, we need to concat the key and slot number before hashing
        j[1]  = 13; // Slot `ethers.utils.keccak256(ethers.utils.concat([ethers.utils.zeroPad(1, 32),  ethers.utils.zeroPad(7, 32)]));`
        j[2]  = 14; // Slot `ethers.utils.keccak256(ethers.utils.concat([ethers.utils.zeroPad(2, 32),  ethers.utils.zeroPad(7, 32)]));`
        j[3]  = 15; // Slot `ethers.utils.keccak256(ethers.utils.concat([ethers.utils.zeroPad(3, 32),  ethers.utils.zeroPad(7, 32)]));`
        j[16] = 16; // Slot `ethers.utils.keccak256(ethers.utils.concat([ethers.utils.zeroPad(16, 32), ethers.utils.zeroPad(7, 32)]));`
        j[17] = 17; // Slot `ethers.utils.keccak256(ethers.utils.concat([ethers.utils.zeroPad(17, 32), ethers.utils.zeroPad(7, 32)]));`

        // Slot `ethers.utils.keccak256(ethers.utils.concat([ethers.utils.zeroPad("0x91AD4632092830e32d1a9e078b592aFE31c26977", 32), ethers.utils.zeroPad(8, 32)]));`
        k[0x91AD4632092830e32d1a9e078b592aFE31c26977] = 18;
    }   
}