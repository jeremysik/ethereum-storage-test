# Ethereum Storage Test

This project demonstrates how the Ethereum Virtual Machine (EVM) stores smart contract data.

## Setup
I have already deployed the StorageTest contract to Ropsten. If you just want to use that contract, skip to step (5).
1. Install packages: `npm install`
2. Generate a signer account: `npm run generate`
3. View the generated signer account: `npm run account`
4. Send ETH to signer account using the details found in step (2), ensure you are on the Ropsten test network.
5. Have a look at the contract `./contracts/StorageTest.sol`, my comments tell you which storage slots variables should be in.
6. You can open a console with: `npm run console`
7. Use console commands to verify the values in each storage slot and compare these with the values set in the contract. See below for a list of commands.

## Console Commands
### Get Value of Storage Slot
`await ethers.provider.getStorageAt(contractAddress, slot);`

*Examples*

Get value at storage slot 0:

`await ethers.provider.getStorageAt("0xD6e74bce3C3565d477caDDb3448B60c8F7C72c36", 0);`

Get value at storage slot 0x036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0:

`await ethers.provider.getStorageAt("0xD6e74bce3C3565d477caDDb3448B60c8F7C72c36", "0x036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0");`

### Calculate keccak256 Hash

`ethers.utils.keccak256(toHash);`

*Examples*

Find storage slot for first element of dynamic array 'h', where it's storage slot is 5:

`ethers.utils.keccak256(ethers.utils.zeroPad(5, 32));`

Find storage slot for element in address->uint256 mapping 'k' with key '0x91AD4632092830e32d1a9e078b592aFE31c26977':

`ethers.utils.keccak256(ethers.utils.concat([ethers.utils.zeroPad("0x91AD4632092830e32d1a9e078b592aFE31c26977", 32),  ethers.utils.zeroPad(8, 32)]));`

### Tips

If you really want to, you can throw it all in one line:

`await ethers.provider.getStorageAt("0xD6e74bce3C3565d477caDDb3448B60c8F7C72c36", ethers.utils.keccak256(ethers.utils.concat([ethers.utils.zeroPad("0x91AD4632092830e32d1a9e078b592aFE31c26977", 32),  ethers.utils.zeroPad(8, 32)])));`