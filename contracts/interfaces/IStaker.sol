// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IStaker {
    function stake(
        bytes32 token,
        address account,
        bytes32 debtType,
        uint256 amount
    ) external;

    function unstake(
        bytes32 token,
        address account,
        bytes32 debtType,
        uint256 amount
    ) external;

    function getStaked(bytes32 token, address account, bytes32 debtType) external view returns (uint256);

    function getClaimable(bytes32 token, address account, bytes32 debtType, uint256 collateralRate) external view returns (uint256);

    function getCollateralRate(bytes32 token, address account, bytes32 debtType) external view returns (uint256);
}
