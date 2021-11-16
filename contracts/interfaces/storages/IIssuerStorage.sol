// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IIssuerStorage {
    struct Debt {
        mapping(bytes32 => uint256) Debt; 
        mapping(bytes32 => uint256) OriginalDebt; 
        uint256 Time;
    }

    function setDebt(
        bytes32 stake,
        address account,
        bytes32 debtType,
        uint256 amount,
        uint256 originalAmount,
        uint256 time
    ) external;

    function getDebt(
        bytes32 stake,
        address account,
        bytes32 debtType
    ) external
      view
      returns (
            uint256 amount,
            uint256 originalAmount,
            uint256 time
      );

    function setTotal(bytes32 debtType, uint256 amount, uint256 originalAmount, uint256 time) external;
    function getTotal(bytes32 debtType) external view returns (uint256, uint256, uint256);
}
