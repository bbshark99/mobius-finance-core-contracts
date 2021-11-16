// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface ISynthMintableControl {
    function isFrozen(string calldata synth) external view returns (bool);
    function freeze(string calldata synth) external returns (bool);
    function unFreeze(string calldata synth) external returns (bool);

    function isFrozenForShort(bytes32 synth) external view returns (bool);
    function freezeForShort(bytes32 synth) external returns (bool);
    function unFreezeForShort(bytes32 synth) external returns (bool);
}
