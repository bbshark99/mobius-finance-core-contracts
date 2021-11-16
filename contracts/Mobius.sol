// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

import './lib/PreciseMath.sol';
import './lib/SafeERC20.sol';
import './base/Pausable.sol';
import './base/Importable.sol';
import './interfaces/IMobius.sol';
import './interfaces/IStaker.sol';
import './interfaces/ITrader.sol';
import './interfaces/IAssetPrice.sol';
import './interfaces/ISetting.sol';
import './interfaces/IIssuer.sol';
import './interfaces/ILiquidator.sol';
import './interfaces/IERC20.sol';
import "./lib/ReentrancyGuard.sol";

contract Mobius is Pausable, Importable, IMobius, ReentrancyGuard{
    using PreciseMath for uint256;
    using SafeERC20 for IERC20;

    bytes32 public override nativeCoin;

    constructor(IResolver _resolver, bytes32 _nativeCoin) Importable(_resolver) {
        nativeCoin = _nativeCoin;
        setContractName(CONTRACT_MOBIUS);
        imports = [
            CONTRACT_STAKER,
            CONTRACT_ASSET_PRICE,
            CONTRACT_SETTING,
            CONTRACT_ISSUER,
            CONTRACT_TRADER,
            CONTRACT_MOBIUS_TOKEN,
            CONTRACT_LIQUIDATOR,
            LIQUIDATION_FEE_ADDRESS
        ];
    }

    function Staker() private view returns (IStaker) {
        return IStaker(requireAddress(CONTRACT_STAKER));
    }

    function AssetPrice() private view returns (IAssetPrice) {
        return IAssetPrice(requireAddress(CONTRACT_ASSET_PRICE));
    }

    function Setting() private view returns (ISetting) {
        return ISetting(requireAddress(CONTRACT_SETTING));
    }

    function Issuer() private view returns (IIssuer) {
        return IIssuer(requireAddress(CONTRACT_ISSUER));
    }

    function Trader() private view returns (ITrader) {
        return ITrader(requireAddress(CONTRACT_TRADER));
    }

    function Liquidator() private view returns (ILiquidator) {
        return ILiquidator(requireAddress(CONTRACT_LIQUIDATOR));
    }

    function mintFromCoin(uint256 collateralRate) external override payable nonReentrant returns (uint256) {
        _stake(nativeCoin, USD, msg.value);
        uint256 minted = _mint(nativeCoin, msg.value, USD, collateralRate);
        return minted;
    }

    function mintFromToken(bytes32 stake, uint256 amount, uint256 collateralRate) external override nonReentrant returns (uint256) {
        require(stake != nativeCoin, 'Mobius: Native Coin use "mintFromCoin" function');

        _stake(stake, USD, amount);
        uint256 minted = _mint(stake, amount, USD, collateralRate);
        return minted;
    }

    function mintFromPreviousStake(bytes32 stake, uint256 amount) external override notPaused nonReentrant returns (bool) {
        Issuer().issueDebtWithPreviousStake(stake, msg.sender, USD, amount);
        emit Minted(msg.sender, stake, 0, amount);
        return true;
    }

    function shortFromCoin(bytes32 debtType, uint256 collateralRate) external override payable nonReentrant returns (uint256) {
        _stake(nativeCoin, debtType, msg.value);
        uint256 minted = _mint(nativeCoin, msg.value, debtType, collateralRate);
        return minted;
    }

    function shortFromToken(bytes32 stake, uint256 amount, bytes32 debtType, uint256 collateralRate) external override nonReentrant returns (uint256) {
        require(stake != nativeCoin, 'Mobius: Native Coin use "shortFromToken" function');

        _stake(stake, debtType, amount);
        uint256 minted = _mint(stake, amount, debtType, collateralRate);
        return minted;
    }

    function shortFromPreviousStake(bytes32 stake, bytes32 debtType, uint256 amount) external override notPaused nonReentrant returns (bool) {
        Issuer().issueDebtWithPreviousStake(stake, msg.sender, debtType, amount);
        emit Shorted(msg.sender, stake, debtType, 0, amount);
        return true;
    }

    function _mint(
        bytes32 stake,
        uint256 amount,
        bytes32 debtType,
        uint256 collateralRate
    ) internal notPaused returns (uint256){
        uint256 safeCollateralRate = Setting().getCollateralRate(stake, debtType);
        require(safeCollateralRate > 0, 'Mobius: Missing Collateral Rate');
        require(collateralRate >= safeCollateralRate, 'Mobius: Collateral Rate too low');

        uint256 issueAmountInUSD = amount * (AssetPrice().getPrice(stake)) / (collateralRate);
        uint256 issueDebtInSynth = Issuer().issueDebt(stake, msg.sender, debtType, issueAmountInUSD);

        if (debtType == USD) {
            emit Minted(msg.sender, stake, amount, issueAmountInUSD);
        } else {
            emit Shorted(msg.sender, stake, debtType, amount, issueDebtInSynth);
        }
        return issueDebtInSynth;
    }

    function burn(bytes32 stake, bytes32 debtType, uint256 amount, bool withdraw) external override notPaused nonReentrant returns (uint256, uint256) {
        uint256 beforeCollateralRate = Staker().getCollateralRate(stake, msg.sender, debtType);
        uint256 burnAmount = Issuer().burnDebt(stake, msg.sender, debtType, amount, msg.sender);

        uint256 claimable = 0;
        if (withdraw) {
            claimable = Staker().getClaimable(stake, msg.sender, debtType, beforeCollateralRate);
            _claim(stake, debtType, claimable, msg.sender);
        }

        emit Burned(msg.sender, stake, debtType, burnAmount);
        return (burnAmount, claimable);
    }

    function claim(
        bytes32 stake,
        bytes32 debtType,
        uint256 amount
    ) external override notPaused nonReentrant returns (bool) {
        uint256 safeCollateralRate = Setting().getCollateralRate(stake, debtType);
        uint256 claimable = Staker().getClaimable(stake, msg.sender, debtType, safeCollateralRate);
        require(claimable >= amount, 'Mobius: transfer amount exceeds claimable');
        return _claim(stake, debtType, amount, msg.sender);
    }

    function _claim(        
        bytes32 stake,
        bytes32 debtType,
        uint256 amount,
        address addr
    ) internal returns (bool) {
        Staker().unstake(stake, addr, debtType, amount);

        if (stake == nativeCoin) {
            payable(addr).transfer(amount);
        } else {
            IERC20 token = IERC20(requireAsset('Stake', stake));
            token.safeTransfer(addr, amount.decimalsTo(PreciseMath.DECIMALS(), token.decimals()));
        }
        emit Claimed(addr, stake, addr, debtType, amount);
        return true;
    }

    function stakeFromCoin(bytes32 debtType) external override payable nonReentrant returns (bool) {
        require(Issuer().getDebt(nativeCoin, msg.sender, debtType) > 0, 'Mobius: Debt must be greater than zero');

        _stake(nativeCoin, debtType, msg.value);
        emit Staked(msg.sender, nativeCoin, debtType, msg.value);
        return true;
    }

    function stakeFromToken(bytes32 stake, bytes32 debtType, uint256 amount) external override nonReentrant returns (bool) {
        require(stake != nativeCoin, 'Mobius: Native Coin use "mintFromCoin" function');
        require(Issuer().getDebt(stake, msg.sender, debtType) > 0, 'Mobius: Debt must be greater than zero');

        _stake(stake, debtType, amount);
        emit Staked(msg.sender, stake, debtType, amount);
        return true;
    }

    function _stake(
        bytes32 stake,
        bytes32 debtType,
        uint256 amount
    ) private notPaused {
        require(amount > 0, 'Mobius: amount must be greater than zero');

        if (stake != nativeCoin) {
            address stakeAddress = requireAsset('Stake', stake);
            IERC20 token = IERC20(stakeAddress);
            token.safeTransferFrom(
                msg.sender,
                address(this),
                amount.decimalsTo(PreciseMath.DECIMALS(), token.decimals())
            );
        }

        Staker().stake(stake, msg.sender, debtType, amount);
    }

    function trade(
        bytes32 fromSynth,
        uint256 fromAmount,
        bytes32 toSynth
    ) external override notPaused nonReentrant returns (uint256) {
        (uint256 tradingAmount, uint256 tradingFee, uint256 fromSynthPrice, uint256 toSynthPirce) =
            Trader().trade(msg.sender, fromSynth, fromAmount, toSynth);

        emit Traded(
            msg.sender,
            fromSynth,
            toSynth,
            fromAmount,
            tradingAmount,
            tradingFee,
            fromSynthPrice,
            toSynthPirce
        );
        return tradingAmount;
    }

    function liquidate(
        bytes32 stake,
        address account,
        bytes32 debtType,
        uint256 amount
    ) external override notPaused nonReentrant returns (uint256) {
        uint256 liquidable = Liquidator().getLiquidable(stake, account, debtType);
        require(liquidable >= amount, 'Mobius: liquidate amount exceeds liquidable');
 
        (uint256 toPayer,uint256 toPlat) = Liquidator().getUnstakable(stake, debtType, amount);
        uint256 unstakable = toPayer + toPlat;
        Issuer().burnDebt(stake, account, debtType, amount, msg.sender);
        Staker().unstake(stake, account, debtType, unstakable);

        if (stake == nativeCoin) {
            payable(msg.sender).transfer(toPayer);
            payable(requireAddress(LIQUIDATION_FEE_ADDRESS)).transfer(toPlat);
        } else {
            IERC20 token = IERC20(requireAsset('Stake', stake));
            token.safeTransfer(msg.sender, toPayer.decimalsTo(PreciseMath.DECIMALS(), token.decimals()));
            token.safeTransfer(requireAddress(LIQUIDATION_FEE_ADDRESS), toPlat.decimalsTo(PreciseMath.DECIMALS(), token.decimals()));
        }

        emit Liquidated(msg.sender, stake, account, debtType, unstakable, amount);
        return toPayer;
    }
}
