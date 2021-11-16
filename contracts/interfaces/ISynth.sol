// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface ISynth {
    function category() external view returns (bytes32);

    function mint(address account, uint256 amount) external returns (bool);

    function burn(address account, uint256 amount) external returns (bool);
}
