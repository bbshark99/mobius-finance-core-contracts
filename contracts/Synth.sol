// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

import './base/Token.sol';
import './base/Importable.sol';
import './interfaces/ISynth.sol';
import './interfaces/ISynthMintableControl.sol';

contract Synth is Importable, Token, ISynth {
    bytes32 private _category;

    constructor(
        address __issuer,
        string memory __name,
        string memory __symbol,
        bytes32 __contractName,
        bytes32 __category,
        IResolver _resolver
    ) Token(__name,__symbol,__contractName) Importable(_resolver){
        setManager(__issuer);
        _category = __category;
        imports = [
            SYNTH_MINTABLE_CONTROL
        ];
    }

    function category() external override view returns (bytes32) {
        return _category;
    }

    function SynthMintableControl() private view returns (ISynthMintableControl) {
        return ISynthMintableControl(requireAddress(SYNTH_MINTABLE_CONTROL));
    }

    function mint(address account, uint256 amount)
        external
        override
        onlyManager(CONTRACT_ISSUER)
        returns (bool)
    {
        require(SynthMintableControl().isFrozen(_name) == false, "Synth is currently frozen");

        _mint(account, amount);
        return true;
    }

    function burn(address account, uint256 amount)
        external
        override
        onlyManager(CONTRACT_ISSUER)
        returns (bool)
    {
        _burn(account, amount);
        return true;
    }
}
