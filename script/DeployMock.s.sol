//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { WXFI } from "@src/mock/tokens/WXFI.sol";
import { WETH }  from "@src/mock/tokens/WETH.sol";
import { XFT }  from "@src/mock/tokens/XFT.sol";
import { eMPX }  from "@src/mock/tokens/eMPX.sol";
import { EXE }  from "@src/mock/tokens/EXE.sol";
import { XUSD }  from "@src/mock/tokens/XUSD.sol";
import { USDT }  from "@src/mock/tokens/USDT.sol";
import { USDC }  from "@src/mock/tokens/USDC.sol";
import { lpXFI }  from "@src/mock/tokens/lpXFI.sol";
import { lpUSD }  from "@src/mock/tokens/lpUSD.sol";
import { lpMPX }  from "@src/mock/tokens/lpMPX.sol";

import {console} from 'forge-std/console.sol';
contract DeployScript is Script {

    string constant TEST_MNEMONIC = "test test test test test test test test test test test junk";
    string constant TEST_CHAIN_NAME = "CrossFi Testnet";

    bool mockTokenDeployed = false;

    IERC20 wxfi;
    IERC20 weth;
    IERC20 xft;
    IERC20 empx;
    IERC20 exe;
    IERC20 xusd;
    IERC20 usdt;
    IERC20 usdc;
    IERC20 lpxfi;
    IERC20 lpusd;
    IERC20 lpmpx;    

    address deployer;
    string chainName;

    function setUp() public {}

    modifier parseEnv() {
        console.log(vm.envOr("PRIVATE_KEY", vm.deriveKey(TEST_MNEMONIC, 0)));
        deployer = vm.addr(vm.envOr("PRIVATE_KEY", vm.deriveKey(TEST_MNEMONIC, 0)));
        chainName = vm.envOr("CHAIN_NAME", TEST_CHAIN_NAME);
        _;
    }
    
    modifier broadcast() {
        vm.startBroadcast(deployer);
        _;
        vm.stopBroadcast();
    }

    function run() 
        public 
            parseEnv 
            broadcast 
        returns (
            address[] memory mockTokens
        ) 
    {
        setupMockTokens();
        
        mockTokens = new address[](11);
        mockTokens[0] = address(wxfi);
        mockTokens[1] = address(weth);
        mockTokens[2] = address(xft);
        mockTokens[3] = address(empx);
        mockTokens[4] = address(exe);
        mockTokens[5] = address(xusd);
        mockTokens[6] = address(usdt);
        mockTokens[7] = address(usdc);
        mockTokens[8] = address(lpxfi);
        mockTokens[9] = address(lpusd);
        mockTokens[10] = address(lpmpx);          
    }

    function setupMockTokens() public {
        wxfi = new WXFI();
        weth = new WETH();
        xft = new XFT(deployer);
        empx = new eMPX(deployer);
        exe = new EXE(deployer);
        xusd = new XUSD(deployer);
        usdt = new USDT(deployer);
        usdc = new USDC(deployer);
        lpxfi = new lpXFI(deployer);
        lpusd = new lpUSD(deployer);
        lpmpx = new lpMPX(deployer);    
    }
}