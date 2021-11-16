// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

import './Ownable.sol';
import '../lib/Strings.sol';

contract Pausable is Ownable {
    using Strings for string;
    
    bool public paused;

    event PauseChanged(bool indexed previousValue, bool indexed newValue);

    modifier notPaused() {
        require(!paused, contractName.concat(': paused'));
        _;
    }

    constructor() {
        paused = false;
    }

    function setPaused(bool _paused) external onlyOwner {
        if (paused == _paused) return;
        emit PauseChanged(paused, _paused);
        paused = _paused;
    }
}
