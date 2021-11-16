// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface ISettingStorage {

    function setUint(
        bytes32 key,
        bytes32 field1,
        bytes32 field2,
        uint256 value
    ) external;

    function getUint(bytes32 key, bytes32 field1, bytes32 field2) external view returns (uint256);
}
