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
} from "@src/LendingPoolState.sol";

import { IInvestmentModule } from "@src/interfaces/IInvestmentModule.sol";
import { InvestmentModule } from "@src/invest/InvestmentModule.sol";
import {ILendingPool} from "@src/interfaces/ILendingPool.sol";
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
            address poolFactoryAddress, 
            address oracleAddress,
            address investAddress,
            address[] memory mockTokens,
            address[] memory pools,
            address deployerAddress
        ) 
    {
        DIAOracleV2 oracle = setupMockOracle();
        IInvestmentModule investModule = setupInvestmentModule(); 
        
        LendingPoolFactory poolFactory = new LendingPoolFactory();
        setupMockTokens();
        pools = new address[](5);
        (
            pools[0],
            pools[1],
            pools[2],
            pools[3],
            pools[4]
        ) = setupLendingPools(poolFactory, oracle, investModule);        

        deployerAddress = deployer;
        poolFactoryAddress = address(poolFactory);
        oracleAddress = address(oracle);
        investAddress = address(investModule);
        
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

    function setupMockOracle() public returns(DIAOracleV2 oracle) {
        if (!mockTokenDeployed)
            oracle = new DIAOracleV2(); 
        else
            oracle = DIAOracleV2(address(0xa513E6E4b8f2a923D98304ec87F64353C4D5C853)); 
    }

    function setupInvestmentModule() public returns(IInvestmentModule investModule) {
        if (!mockTokenDeployed)
            investModule = new InvestmentModule(); 
        else
            investModule = IInvestmentModule(address(0xa513E6E4b8f2a923D98304ec87F64353C4D5C853)); 
    }

    function setupMockTokens() public {
        if (mockTokenDeployed) {
            wxfi = IERC20(address(0x8A791620dd6260079BF849Dc5567aDC3F2FdC318));
            weth = IERC20(address(0x610178dA211FEF7D417bC0e6FeD39F05609AD788));
            xft = IERC20(address(0xB7f8BC63BbcaD18155201308C8f3540b07f84F5e));
            empx = IERC20(address(0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0));
            exe = IERC20(address(0x0DCd1Bf9A1b36cE34237eEaFef220932846BCD82));
            xusd = IERC20(address(0x9A676e781A523b5d0C0e43731313A708CB607508));
            usdt = IERC20(address(0x0B306BF915C4d645ff596e518fAf3F9669b97016));
            usdc = IERC20(address(0x959922bE3CAee4b8Cd9a407cc3ac1C251C2007B1));
            lpxfi = IERC20(address(0x9A9f2CCfdE556A7E9Ff0848998Aa4a0CFD8863AE));
            lpusd = IERC20(address(0x68B1D87F95878fE05B998F19b66F4baba5De1aed));
            lpmpx = IERC20(address(0x3Aa5ebB10DC797CAC828524e59A333d0A371443c));
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

    function setupLendingPools(LendingPoolFactory factory, DIAOracleV2 oracle, IInvestmentModule investModule) 
        public 
        returns(
            address USDT_Pool,
            address XUSD_Pool,    
            address lpXFI_Pool, 
            address lpUSD_Pool, 
            address lpMPX_pool 
        ) 
    {
        USDT_Pool = setupUSDTLendingPool(factory, oracle, investModule);
        XUSD_Pool = setupXUSDLendingPool(factory, oracle, investModule);
        (
            lpXFI_Pool, 
            lpUSD_Pool, 
            lpMPX_pool 
        ) = setupLPLendingPool(factory, oracle, investModule);
    }

    function setupUSDTLendingPool(LendingPoolFactory factory, DIAOracleV2 oracle, IInvestmentModule investModule) public returns(address USDT_Pool) {
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
            collaterals: collaterals,
            investModule: investModule
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

        USDT_Pool = factory.createLendingPool();
        ILendingPool(USDT_Pool).initialize(initParam);
    }

    function setupXUSDLendingPool(LendingPoolFactory factory, DIAOracleV2 oracle, IInvestmentModule investModule) public returns(address xUSD_Pool) {
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
            collaterals: collaterals,
            investModule: investModule
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

        xUSD_Pool = factory.createLendingPool();
        ILendingPool(xUSD_Pool).initialize(initParam);
    }

    function setupLPLendingPool(LendingPoolFactory factory, DIAOracleV2 oracle, IInvestmentModule investModule) public returns(address lpXFI_Pool, address lpUSD_Pool, address lpMPX_Pool) {
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
            collaterals: collaterals,
            investModule: investModule
        });

        InitializeTokenConfig memory _tokenConfigUSD = InitializeTokenConfig({
            principalToken: lpusd,
            principalKey: "lpUSD/usd",
            oracle: oracle,
            collaterals: collaterals,
            investModule: investModule
        });

        InitializeTokenConfig memory _tokenConfigMPX = InitializeTokenConfig({
            principalToken: lpmpx,
            principalKey: "lpMPX/usd",
            oracle: oracle,
            collaterals: collaterals,
            investModule: investModule
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

        lpXFI_Pool = factory.createLendingPool();

        lpUSD_Pool = factory.createLendingPool();

        lpMPX_Pool = factory.createLendingPool();

        ILendingPool(lpXFI_Pool).initialize(InitializeParam({
            tokenConfig: _tokenConfigXFI,
            feeConfig: _feeConfig,
            riskConfig: _riskConfig,
            rateConfig: _rateConfig
        }));
        ILendingPool(lpUSD_Pool).initialize(InitializeParam({
            tokenConfig: _tokenConfigUSD,
            feeConfig: _feeConfig,
            riskConfig: _riskConfig,
            rateConfig: _rateConfig
        }));
        ILendingPool(lpMPX_Pool).initialize(InitializeParam({
            tokenConfig: _tokenConfigMPX,
            feeConfig: _feeConfig,
            riskConfig: _riskConfig,
            rateConfig: _rateConfig
        }));
    }
}