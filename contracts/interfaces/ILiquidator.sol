// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;
pragma experimental ABIEncoderV2;

interface ILiquidator {

    function canLiquidate(bytes32 stake, address account, bytes32 debtType) external view returns (bool);

    function getLiquidable(bytes32 stake, address account, bytes32 debtType) external view returns (uint256);

    function getUnstakable(bytes32 stake, bytes32 debtType, uint256 amount) external view returns (uint256,uint256);

}
