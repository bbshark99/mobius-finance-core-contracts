// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IDynamicTradingFee {
    function getDynamicTradingFeeRate(bytes32 synth, uint256 amountInUSD, bool isShort) external view returns (uint256);
    function getPositionInfo(bytes32 synth) external view returns(uint256 long, uint256 short);
}
