// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IRewardCollateralStorage {
    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many collateral the user has staked.
        uint256 pending; //unclaimed reward.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of MOTs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accMotPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws collateral to a pool. Here's what happens:
        //   1. The pool's `accMotPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }
    // Info of each pool.
    struct PoolInfo {
        bytes32 poolName;
        uint256 allocPoint; // How many allocation points assigned to this pool. MOTs to distribute per block.
        uint256 lastRewardBlock; // Last block number that MOTs distribution occurs.
        uint256 accMOTPerShare; // Accumulated MOTs per share, times 1e12. See below.
        uint256 totalStakeAmount;// all user's staking amount for this pool 
    }

    function poolLength() external view returns (uint256);
    function poolInfo(uint256 pid) external view returns(bytes32,uint256,uint256,uint256,uint256);
    function poolNameToId(bytes32 poolName) external view returns(uint256);
    function totalAllocPoint() external view returns (uint256);
    function userInfo(uint256 pid, address addr) external view returns (uint256, uint256, uint256);

    function addPool(bytes32 poolName,uint256 allocPoint,uint256 lastRewardBlock) external returns (bool);
    function updateAllocPoint(bytes32 poolName,uint256 allocPoint) external returns (bool);
    function updatePool(uint256 pid, uint256 lastRewardBlock, uint256 accMOTPerShare, uint256 totalStakeAmount) external returns (bool);
    function updateUser(uint256 pid, address addr, uint256 amount, uint256 pending, uint256 rewardDebt) external returns (bool);
}
