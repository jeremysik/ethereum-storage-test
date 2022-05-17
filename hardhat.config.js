require("@nomiclabs/hardhat-waffle");
const EthUtil   = require("ethereumjs-util");
const bip39     = require("bip39");
const { hdkey } = require("ethereumjs-wallet");
const qrcode    = require("qrcode-terminal");
const fs        = require("fs");

task(
    "generate",
    "Create a mnemonic for builder deploys",
    async (_, { ethers }) => {
        const mnemonic = bip39.generateMnemonic();

        const seed = await bip39.mnemonicToSeed(mnemonic);

        const hdwallet     = hdkey.fromMasterSeed(seed);
        const walletHdpath = "m/44'/60'/0'/0/";
        const accountIndex = 0;
        const fullPath     = walletHdpath + accountIndex;

        const wallet  = hdwallet.derivePath(fullPath).getWallet();
        const address = `0x${EthUtil.privateToAddress(wallet.privateKey).toString("hex")}`;

        console.log(`Account Generated as ${address} and set as mnemonic written to mnemonic.txt`);

        fs.writeFileSync("./mnemonic.txt", mnemonic.toString());
    }
);

task(
    "account",
    "Get balance informations for the deployment account.",
    async (_, { ethers }) => {
        const mnemonic     = fs.readFileSync("./mnemonic.txt").toString().trim();
        const seed         = await bip39.mnemonicToSeed(mnemonic);
        const hdwallet     = hdkey.fromMasterSeed(seed);
        const walletHdpath = "m/44'/60'/0'/0/";
        const accountIndex = 0;
        const fullPath     = walletHdpath + accountIndex;

        const wallet  = hdwallet.derivePath(fullPath).getWallet();
        const address = `0x${EthUtil.privateToAddress(wallet.privateKey).toString("hex")}`;

        qrcode.generate(address);
        console.log(`Deployer Account is ${address}`);

        for (const network in config.networks) {
            try {
                const provider = new ethers.providers.JsonRpcProvider(
                    config.networks[network].url
                );
                const balance = await provider.getBalance(address);
                console.log(`------ ${network} ------`);
                console.log(`balance: ${ethers.utils.formatEther(balance)}`);
                console.log(`nonce:   ${await provider.getTransactionCount(address)}`);
            } catch (e) {
            }
        }
    }
)

function mnemonic() {
    try {
        return fs.readFileSync("./mnemonic.txt").toString().trim();
    } catch (e) {
        if (defaultNetwork !== "localhost") {
            console.error(
                `mnemonic.txt not found.\nPlease generate a deploy account using 'npm run generate'.\nView the account using 'npm run account'.\nLoad the account with ETH on Ropsten test network before deploying.`
            );
        }
    }
    return "";
}

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
    solidity: "0.8.4",
    networks: {
        ropsten: {
            url: "https://ropsten.infura.io/v3/dfa4904931304c67b67d8fc7dc957cc2",
            accounts: {
                mnemonic: mnemonic()
            }
        }
    }
};