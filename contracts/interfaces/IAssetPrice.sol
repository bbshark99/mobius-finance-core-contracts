// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IAssetPrice {
    function getPrice(bytes32 asset) external view returns (uint256);

    function getPrices(bytes32[] calldata assets) external view returns (uint256[] memory);

    function getPriceAndStatus(bytes32 asset) external view returns (uint256, uint256);

    function getPricesAndStatus(bytes32[] calldata assets) external view returns (uint256[] memory, uint256[] memory);

    function getPriceFromOracle(bytes32 asset)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    event MaxDelayTimeChanged(uint256 indexed previousValue, uint256 indexed newValue);
    event OracleChanged(bytes32 indexed asset, address indexed previousValue, address indexed newValue);
    event OracleRemoved(bytes32 indexed asset, address indexed previousValue);
}
