// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

import './IERC20.sol';

interface IRewardStaking {
    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of MOTs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accMOTPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accMOTPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }
    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken; // Address of LP token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. MOTs to distribute per block.
        uint256 lastRewardBlock; // Last block number that MOTs distribution occurs.
        uint256 accMOTPerShare; // Accumulated MOTs per share, times 1e12. See below.
    }

    function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) external;
    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external;

    function pendingMOT(uint256 _pid, address _user) external view returns (uint256);

    function deposit(uint256 _pid, uint256 _amount) external;
    function claim(uint256 _pid) external;
    function withdraw(uint256 _pid, uint256 _amount) external;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(
        address indexed user,
        uint256 indexed pid,
        uint256 amount
    );
    event SetMOTPerBlock(uint256 indexed newPerBlock);
}
