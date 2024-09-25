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
import { MockRewardModule } from "@src/mock/rewards/MockRewardModule.sol";

import { IInvestmentModule } from "@src/interfaces/IInvestmentModule.sol";
import { IRewardModule } from "@src/interfaces/IRewardModule.sol";
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

    IRewardModule wxfiRewardModule;
    // IERC20 wethRewardModule;
    IRewardModule xftRewardModule;
    IRewardModule empxRewardModule;
    IRewardModule exeRewardModule;
    IRewardModule xusdRewardModule;
    IRewardModule usdtRewardModule;
    IRewardModule usdcRewardModule;
    IRewardModule lpxfiRewardModule;
    IRewardModule lpusdRewardModule;
    IRewardModule lpmpxRewardModule;  

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
            address[] memory mockRewards,
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

        mockRewards = new address[](10);
        mockRewards[0] = address(wxfiRewardModule);
        mockRewards[1] = address(xftRewardModule);
        mockRewards[2] = address(empxRewardModule);
        mockRewards[3] = address(exeRewardModule);
        mockRewards[4] = address(xusdRewardModule);
        mockRewards[5] = address(usdtRewardModule);
        mockRewards[6] = address(usdcRewardModule);
        mockRewards[7] = address(lpxfiRewardModule);
        mockRewards[8] = address(lpusdRewardModule);
        mockRewards[9] = address(lpmpxRewardModule);

    }

    function setupMockOracle() public returns(DIAOracleV2 oracle) {
        if (!mockTokenDeployed)
            oracle = new DIAOracleV2(); 
        else
            oracle = DIAOracleV2(address(0x7bc06c482DEAd17c0e297aFbC32f6e63d3846650)); 
    }

    function setupInvestmentModule() public returns(IInvestmentModule investModule) {
        // if (!mockTokenDeployed)
            investModule = new InvestmentModule(); 
        // else
        //     investModule = IInvestmentModule(address(0xc351628EB244ec633d5f21fBD6621e1a683B1181)); 
    }

    function setupMockTokens() public {
        if (mockTokenDeployed) {
            wxfi = IERC20(address(0xcbEAF3BDe82155F56486Fb5a1072cb8baAf547cc));
            weth = IERC20(address(0x1429859428C0aBc9C2C47C8Ee9FBaf82cFA0F20f));
            xft = IERC20(address(0xB0D4afd8879eD9F52b28595d31B441D079B2Ca07));
            empx = IERC20(address(0x162A433068F51e18b7d13932F27e66a3f99E6890));
            exe = IERC20(address(0x922D6956C99E12DFeB3224DEA977D0939758A1Fe));
            xusd = IERC20(address(0x5081a39b8A5f0E35a8D959395a630b68B74Dd30f));
            usdt = IERC20(address(0x1fA02b2d6A771842690194Cf62D91bdd92BfE28d));
            usdc = IERC20(address(0xdbC43Ba45381e02825b14322cDdd15eC4B3164E6));
            lpxfi = IERC20(address(0x04C89607413713Ec9775E14b954286519d836FEf));
            lpusd = IERC20(address(0x4C4a2f8c81640e47606d3fd77B353E87Ba015584));
            lpmpx = IERC20(address(0x21dF544947ba3E8b3c32561399E88B52Dc8b2823));
        } else {
            wxfi = new WXFI();
            weth = new WETH(deployer);
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

        if (mockTokenDeployed) {
            wxfiRewardModule = IRewardModule(address(0x8dA47DD12384f3A0c711E0cCb8Ac60D50d0e8cC8));
            xftRewardModule = IRewardModule(address(0x732cc7c39e80d553513174Dc6F3AD6a4A107957F));
            empxRewardModule = IRewardModule(address(0x143E8C6D4114Ea49292D4183bB7df2382A58FC28));
            exeRewardModule = IRewardModule(address(0xa9186cf932e4e05b4606d107361Ae7b6651AF1b7));
            xusdRewardModule = IRewardModule(address(0x31a46feD168ECb9DE7d87E543Ba2e8DD101ad0a0));
            usdtRewardModule = IRewardModule(address(0x49A60936D52A63d9069DD667B8c84E4274d0A0B6));
            usdcRewardModule = IRewardModule(address(0xfDE447BFa4e774606a6b0c73268Bc515a12c09c7));
            lpxfiRewardModule = IRewardModule(address(0x977E2F3aA628f7676d685A3AFe2df48c51C9949a));
            lpusdRewardModule = IRewardModule(address(0x8647AC3a1270c746130418010A368449d1944A82));
            lpmpxRewardModule = IRewardModule(address(0xa79E2BDa2F900A3856a5502FE5f06F13bC7Ac843));
        } else {
            wxfiRewardModule = new MockRewardModule(address(wxfi), address(weth), 3e16);
            xftRewardModule = new MockRewardModule(address(xft), address(weth), 3e16);
            empxRewardModule = new MockRewardModule(address(empx), address(weth), 3e16);
            exeRewardModule = new MockRewardModule(address(exe), address(weth), 3e16);
            xusdRewardModule = new MockRewardModule(address(xusd), address(weth), 3e16);
            usdtRewardModule = new MockRewardModule(address(usdt), address(weth), 3e16);
            usdcRewardModule = new MockRewardModule(address(usdc), address(weth), 3e16);
            lpxfiRewardModule = new MockRewardModule(address(lpxfi), address(weth), 3e16);
            lpusdRewardModule = new MockRewardModule(address(lpusd), address(weth), 3e16);
            lpmpxRewardModule = new MockRewardModule(address(lpmpx), address(weth), 3e16);     
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
        InitialCollateralInfo[] memory collaterals = new InitialCollateralInfo[](5);
        collaterals[0] = InitialCollateralInfo({
            tokenAddress: xusd,
            collateralKey: "xusd/usd"
        });

        collaterals[1] = InitialCollateralInfo({
            tokenAddress: empx,
            collateralKey: "empx/usd"
        });

        collaterals[2] = InitialCollateralInfo({
            tokenAddress: xft,
            collateralKey: "xft/usd"
        });
        
        collaterals[3] = InitialCollateralInfo({
            tokenAddress: lpusd,
            collateralKey: "lpusd/usd"
        });

        collaterals[4] = InitialCollateralInfo({
            tokenAddress: lpmpx,
            collateralKey: "lpmpx/usd"
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
        ILendingPool(USDT_Pool).setTokenRewardModule(address(usdt), usdtRewardModule);
        ILendingPool(USDT_Pool).setTokenRewardModule(address(xusd), xusdRewardModule);
        ILendingPool(USDT_Pool).setTokenRewardModule(address(empx), empxRewardModule);
        ILendingPool(USDT_Pool).setTokenRewardModule(address(xft), xftRewardModule);
        ILendingPool(USDT_Pool).setTokenRewardModule(address(lpusd), lpusdRewardModule);
        ILendingPool(USDT_Pool).setTokenRewardModule(address(lpmpx), lpmpxRewardModule);

    }

    function setupXUSDLendingPool(LendingPoolFactory factory, DIAOracleV2 oracle, IInvestmentModule investModule) public returns(address xUSD_Pool) {
        InitialCollateralInfo[] memory collaterals = new InitialCollateralInfo[](5);
        collaterals[0] = InitialCollateralInfo({
            tokenAddress: xusd,
            collateralKey: "xusd/usd"
        });

        collaterals[1] = InitialCollateralInfo({
            tokenAddress: lpmpx,
            collateralKey: "lpmpx/usd"
        });

        collaterals[2] = InitialCollateralInfo({
            tokenAddress: wxfi,
            collateralKey: "wxfi/usd"
        });

        collaterals[3] = InitialCollateralInfo({
            tokenAddress: xft,
            collateralKey: "lpxfi/usd"
        });
        
        collaterals[4] = InitialCollateralInfo({
            tokenAddress: exe,
            collateralKey: "exe/usd"
        });
        
        InitializeTokenConfig memory _tokenConfig = InitializeTokenConfig({
            principalToken: usdc,
            principalKey: "usdc/usd",
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
        ILendingPool(xUSD_Pool).setTokenRewardModule(address(usdc), usdcRewardModule);
        ILendingPool(xUSD_Pool).setTokenRewardModule(address(lpmpx), lpmpxRewardModule);
        ILendingPool(xUSD_Pool).setTokenRewardModule(address(wxfi), wxfiRewardModule);
        ILendingPool(xUSD_Pool).setTokenRewardModule(address(xft), xftRewardModule);
        ILendingPool(xUSD_Pool).setTokenRewardModule(address(exe), exeRewardModule);
        ILendingPool(xUSD_Pool).setTokenRewardModule(address(xusd), xusdRewardModule);
    }

    function setupLPLendingPool(LendingPoolFactory factory, DIAOracleV2 oracle, IInvestmentModule investModule) public returns(address lpXFI_Pool, address lpUSD_Pool, address lpMPX_Pool) {
        InitialCollateralInfo[] memory collaterals = new InitialCollateralInfo[](4);
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
        
        InitializeTokenConfig memory _tokenConfigXFI = InitializeTokenConfig({
            principalToken: lpxfi,
            principalKey: "lpxfi/usd",
            oracle: oracle,
            collaterals: collaterals,
            investModule: investModule
        });

        InitializeTokenConfig memory _tokenConfigUSD = InitializeTokenConfig({
            principalToken: lpusd,
            principalKey: "lpusd/usd",
            oracle: oracle,
            collaterals: collaterals,
            investModule: investModule
        });

        InitializeTokenConfig memory _tokenConfigMPX = InitializeTokenConfig({
            principalToken: lpmpx,
            principalKey: "lpmpx/usd",
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