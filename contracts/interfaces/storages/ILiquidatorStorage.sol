// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;
pragma experimental ABIEncoderV2;

interface ILiquidatorStorage {
    function setDeadline(bytes32 stake, uint256 time) external;
    function getDeadline(bytes32 stake) external view returns (uint256);
}
