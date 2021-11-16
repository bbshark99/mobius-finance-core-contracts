// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface ITraderStorage {
    function incrementTradingFee(
        address account,
        uint256 amount
    ) external returns (uint256);

    function getTradingFee(address account) external view returns (uint256);
}
