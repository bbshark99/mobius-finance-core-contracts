// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface ISetting {
    function getCollateralRate(bytes32 asset, bytes32 debtType) external view returns (uint256);

    function getLiquidationRate(bytes32 asset, bytes32 debtType) external view returns (uint256);

    function getLiquidationFeeRate(bytes32 asset) external view returns (uint256);

    function getLiquidationDelay() external view returns (uint256);

    function getTradingFeeRate(bytes32 asset) external view returns (uint256);

    function getMinStakeTime() external view returns (uint256);

    function getMintPeriodDuration() external view returns (uint256);

    function getMaxTradingFeeOffsetRate() external view returns (uint256);

    event SettingChanged(bytes32 indexed name, bytes32 indexed field, uint256 previousValue, uint256 newValue);
    event SettingChanged(bytes32 indexed name, bytes32 indexed field, address previousValue, address newValue);
}
