// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface ITrader {
    function trade(
        address account,
        bytes32 fromSynth,
        uint256 fromAmount,
        bytes32 toSynth
    )
        external
        returns (
            uint256 tradingAmount,
            uint256 tradingFee,
            uint256 fromSynthPrice,
            uint256 toSynthPirce
        );

    function getTradingAmountAndFee(
        bytes32 fromSynth,
        uint256 fromAmount,
        bytes32 toSynth
    )
        external
        view
        returns (
            uint256 tradingAmount,
            uint256 tradingFee,
            uint256 fromSynthPrice,
            uint256 toSynthPirce,
            uint256 fromStatus,
            uint256 toStatus
        );

    function getTradingFee(address account) external view returns (uint256);
}
