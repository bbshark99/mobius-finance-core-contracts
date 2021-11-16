// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IEscrow {
    function deposit(
        address account,
        uint256 amount,
        uint256 vestTime
    ) external;

    function withdraw(address account, uint256 amount) external;

    function getWithdrawable(address account) external view returns (uint256);

    function getBalance(address account) external view returns (uint256);
}
