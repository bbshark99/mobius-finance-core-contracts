// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IStakerStorage {
    struct Collateral {
        mapping(bytes32 => uint256) Collateral; 
    }

    function incrementStaked(
        bytes32 stake,
        address account,
        bytes32 debtType,
        uint256 amount
    ) external returns (uint256);

    function decrementStaked(
        bytes32 stake,
        address account,
        bytes32 debtType,
        uint256 amount
    ) external returns (uint256);

    function getStaked(bytes32 stake, address account, bytes32 debtType) external view returns (uint256);
}
