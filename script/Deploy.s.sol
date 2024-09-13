//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { DIAOracleV2 } from "@src/oracle/DIAOracleV2Multiupdate.sol";
import { LendingPoolFactory } from "@src/LendingPoolFactory.sol";
import { 
    InitializeParam,
    InitializeTokenConfig,
    InitialCollateralInfo,
    FeeConfig,
    RiskConfig,
    RateConfig
} from "@src/LendingPoolStorage.sol";
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
    string constant TEST_CHAIN_NAME = "anvil";

    bool mockTokenDeployed = true;

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
        deployer = vm.addr(vm.envOr("DEPLOYER_PRIVATE_KEY", vm.deriveKey(TEST_MNEMONIC, 0)));
        chainName = vm.envOr("CHAIN_NAME", TEST_CHAIN_NAME);
        _;
    }
    
    modifier broadcast() {
        vm.startBroadcast(vm.deriveKey(TEST_MNEMONIC, 0));
        _;
        vm.stopBroadcast();
    }

    function run() 
        public 
            parseEnv 
            broadcast 
        returns (
            address poolFactoryAddress, 
            address oracleAddress,
            address[] memory mockTokens,
            address[] memory pools,
            address deployerAddress
        ) 
    {
        DIAOracleV2 oracle = setupMockOracle();
        
        LendingPoolFactory poolFactory = new LendingPoolFactory();
        setupMockTokens();
        setupLendingPools(poolFactory, oracle);        

        deployerAddress = deployer;
        poolFactoryAddress = address(poolFactory);
        oracleAddress = address(oracle);
        
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
        
        pools = poolFactory.getAllPoolAddresses();
    }

    function setupMockOracle() public returns(DIAOracleV2 oracle) {
        if (!mockTokenDeployed)
            oracle = new DIAOracleV2(); 
        else
            oracle = DIAOracleV2(address(0x3D63c50AD04DD5aE394CAB562b7691DD5de7CF6f)); 
    }

    function setupMockTokens() public {
        if (mockTokenDeployed) {
            wxfi = IERC20(address(0x1c9fD50dF7a4f066884b58A05D91e4b55005876A));
            weth = IERC20(address(0x0fe4223AD99dF788A6Dcad148eB4086E6389cEB6));
            xft = IERC20(address(0x71a0b8A2245A9770A4D887cE1E4eCc6C1d4FF28c));
            empx = IERC20(address(0xb185E9f6531BA9877741022C92CE858cDCc5760E));
            exe = IERC20(address(0xAe120F0df055428E45b264E7794A18c54a2a3fAF));
            xusd = IERC20(address(0x193521C8934bCF3473453AF4321911E7A89E0E12));
            usdt = IERC20(address(0x9Fcca440F19c62CDF7f973eB6DDF218B15d4C71D));
            usdc = IERC20(address(0x01E21d7B8c39dc4C764c19b308Bd8b14B1ba139E));
            lpxfi = IERC20(address(0x3C1Cb427D20F15563aDa8C249E71db76d7183B6c));
            lpusd = IERC20(address(0x1343248Cbd4e291C6979e70a138f4c774e902561));
            lpmpx = IERC20(address(0x22a9B82A6c3D2BFB68F324B2e8367f346Dd6f32a));
        } else {
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

    function setupLendingPools(LendingPoolFactory factory, DIAOracleV2 oracle) 
        public 
        returns(
            address USDT_Pool,
            address XUSD_Pool,    
            address lpXFI_Pool, 
            address lpUSD_Pool, 
            address lpMPX_pool 
        ) 
    {
        USDT_Pool = setupUSDTLendingPool(factory, oracle);
        XUSD_Pool = setupXUSDLendingPool(factory, oracle);
        (
            lpXFI_Pool, 
            lpUSD_Pool, 
            lpMPX_pool 
        ) = setupLPLendingPool(factory, oracle);
    }

    function setupUSDTLendingPool(LendingPoolFactory factory, DIAOracleV2 oracle) public returns(address USDT_Pool) {
        InitialCollateralInfo[] memory collaterals = new InitialCollateralInfo[](6);
        collaterals[0] = InitialCollateralInfo({
            tokenAddress: xusd,
            collateralKey: "xusd/usd"
        });

        collaterals[1] = InitialCollateralInfo({
            tokenAddress: empx,
            collateralKey: "empx/usd"
        });

        collaterals[2] = InitialCollateralInfo({
            tokenAddress: wxfi,
            collateralKey: "wxfi/usd"
        });

        collaterals[3] = InitialCollateralInfo({
            tokenAddress: xft,
            collateralKey: "xft/usd"
        });

        collaterals[4] = InitialCollateralInfo({
            tokenAddress: weth,
            collateralKey: "weth/usd"
        });
        
        collaterals[5] = InitialCollateralInfo({
            tokenAddress: exe,
            collateralKey: "exe/usd"
        });
        
        InitializeTokenConfig memory _tokenConfig = InitializeTokenConfig({
            principalToken: usdt,
            principalKey: "usdt/usd",
            oracle: oracle,
            collaterals: collaterals
        });
        
        FeeConfig memory _feeConfig = FeeConfig({
            protocolFeeRate: 0.05e18,
            protocolFeeRecipient: deployer
        });

        RiskConfig memory _riskConfig = RiskConfig({
            loanToValue: 0.75e18, // loan to value (e.g., 75%)
            liquidationThreshold: 0.8e18, // Liquidation threshold (e.g., 80%)
            minimumBorrowToken: 0.1e18,
            borrowTokenCap: 1e27,    
            healthFactorForClose: 0.95e18, // user’s health factor:  0.95<hf<1, the loan is eligible for a liquidation of 50%. user’s health factor:  hf<=0.95, the loan is eligible for a liquidation of 100%.
            liquidationBonus: 0.02e18
        });
        
        RateConfig memory _rateConfig = RateConfig({
            baseRate: 0.02e18, // Base rate (e.g., 2%)
            rateSlope1: 0.04e18, // Slope 1 for utilization below optimal rate (e.g., 4%)
            rateSlope2: 0.2e18, // Slope 2 for utilization above optimal rate (e.g., 20%)
            optimalUtilizationRate: 0.9e18, // Optimal utilization rate (e.g., 80%)
            reserveFactor: 0.08e18 // reserve Factor for protocol (e.g., 8%)
        });

        InitializeParam memory initParam = InitializeParam({
            tokenConfig: _tokenConfig,
            feeConfig: _feeConfig,
            riskConfig: _riskConfig,
            rateConfig: _rateConfig
        });

        USDT_Pool = factory.createLendingPool(initParam);
    }

    function setupXUSDLendingPool(LendingPoolFactory factory, DIAOracleV2 oracle) public returns(address xUSD_Pool) {
        InitialCollateralInfo[] memory collaterals = new InitialCollateralInfo[](6);
        collaterals[0] = InitialCollateralInfo({
            tokenAddress: usdt,
            collateralKey: "usdt/usd"
        });

        collaterals[1] = InitialCollateralInfo({
            tokenAddress: empx,
            collateralKey: "empx/usd"
        });

        collaterals[2] = InitialCollateralInfo({
            tokenAddress: wxfi,
            collateralKey: "wxfi/usd"
        });

        collaterals[3] = InitialCollateralInfo({
            tokenAddress: xft,
            collateralKey: "xft/usd"
        });

        collaterals[4] = InitialCollateralInfo({
            tokenAddress: weth,
            collateralKey: "weth/usd"
        });
        
        collaterals[5] = InitialCollateralInfo({
            tokenAddress: exe,
            collateralKey: "exe/usd"
        });
        
        InitializeTokenConfig memory _tokenConfig = InitializeTokenConfig({
            principalToken: xusd,
            principalKey: "xusd/usd",
            oracle: oracle,
            collaterals: collaterals
        });
        
        FeeConfig memory _feeConfig = FeeConfig({
            protocolFeeRate: 0.05e18,
            protocolFeeRecipient: deployer
        });

        RiskConfig memory _riskConfig = RiskConfig({
            loanToValue: 0.7e18, 
            liquidationThreshold: 0.75e18, 
            minimumBorrowToken: 0.1e18,
            borrowTokenCap: 1e27,    
            healthFactorForClose: 0.95e18, 
            liquidationBonus: 0.02e18
        });
        
        RateConfig memory _rateConfig = RateConfig({
            baseRate: 0.025e18, 
            rateSlope1: 0.05e18, 
            rateSlope2: 0.3e18, 
            optimalUtilizationRate: 0.9e18, 
            reserveFactor: 0.1e18 
        });

        InitializeParam memory initParam = InitializeParam({
            tokenConfig: _tokenConfig,
            feeConfig: _feeConfig,
            riskConfig: _riskConfig,
            rateConfig: _rateConfig
        });

        xUSD_Pool = factory.createLendingPool(initParam);
    }

    function setupLPLendingPool(LendingPoolFactory factory, DIAOracleV2 oracle) public returns(address lpXFI_Pool, address lpUSD_Pool, address lpMPX_Pool) {
        InitialCollateralInfo[] memory collaterals = new InitialCollateralInfo[](6);
        collaterals[0] = InitialCollateralInfo({
            tokenAddress: xusd,
            collateralKey: "xusd/usd"
        });

        collaterals[1] = InitialCollateralInfo({
            tokenAddress: empx,
            collateralKey: "empx/usd"
        });

        collaterals[2] = InitialCollateralInfo({
            tokenAddress: wxfi,
            collateralKey: "wxfi/usd"
        });

        collaterals[3] = InitialCollateralInfo({
            tokenAddress: xft,
            collateralKey: "xft/usd"
        });

        collaterals[4] = InitialCollateralInfo({
            tokenAddress: weth,
            collateralKey: "weth/usd"
        });
        
        collaterals[5] = InitialCollateralInfo({
            tokenAddress: exe,
            collateralKey: "exe/usd"
        });
        
        InitializeTokenConfig memory _tokenConfigXFI = InitializeTokenConfig({
            principalToken: lpxfi,
            principalKey: "lpXFI/usd",
            oracle: oracle,
            collaterals: collaterals
        });

        InitializeTokenConfig memory _tokenConfigUSD = InitializeTokenConfig({
            principalToken: lpusd,
            principalKey: "lpUSD/usd",
            oracle: oracle,
            collaterals: collaterals
        });

        InitializeTokenConfig memory _tokenConfigMPX = InitializeTokenConfig({
            principalToken: lpmpx,
            principalKey: "lpMPX/usd",
            oracle: oracle,
            collaterals: collaterals
        });
        
        FeeConfig memory _feeConfig = FeeConfig({
            protocolFeeRate: 0.05e18,
            protocolFeeRecipient: deployer
        });

        RiskConfig memory _riskConfig = RiskConfig({
            loanToValue: 0.5e18, 
            liquidationThreshold: 0.6e18, 
            minimumBorrowToken: 0.1e18,
            borrowTokenCap: 1e27,    
            healthFactorForClose: 0.95e18, 
            liquidationBonus: 0.02e18
        });
        
        RateConfig memory _rateConfig = RateConfig({
            baseRate: 0.05e18, 
            rateSlope1: 0.08e18, 
            rateSlope2: 0.4e18, 
            optimalUtilizationRate: 0.9e18, 
            reserveFactor: 0.1e18 
        });

        lpXFI_Pool = factory.createLendingPool(InitializeParam({
            tokenConfig: _tokenConfigXFI,
            feeConfig: _feeConfig,
            riskConfig: _riskConfig,
            rateConfig: _rateConfig
        }));

        lpUSD_Pool = factory.createLendingPool(InitializeParam({
            tokenConfig: _tokenConfigUSD,
            feeConfig: _feeConfig,
            riskConfig: _riskConfig,
            rateConfig: _rateConfig
        }));

        lpMPX_Pool = factory.createLendingPool(InitializeParam({
            tokenConfig: _tokenConfigMPX,
            feeConfig: _feeConfig,
            riskConfig: _riskConfig,
            rateConfig: _rateConfig
        }));
    }
}