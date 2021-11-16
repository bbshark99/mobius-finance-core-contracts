// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

interface IRewardTrading {
    function poolLength() external view returns (uint256);
    function poolInfo(uint256) external view returns (bytes32 poolName,uint256 allocPoint,uint256 lastRewardBlock,uint256 accMOTPerShare,uint256 totalStakeAmount);

    function userInfo(uint256,address) external view returns (uint256 amount,uint256 pending,uint256 rewardDebt);

    function motPerBlock() external view returns (uint256);
    function totalAllocPoint() external view returns (uint256);

    function add(bytes32 poolName,uint256 _allocPoint, bool _withUpdate) external;
    function set(bytes32 poolName, uint256 _allocPoint, bool _withUpdate) external;

    function deposit(bytes32 poolName, address _userAddr, uint256 _amount) external ;
    function unDeposit(bytes32 poolName, address _userAddr,uint256 _amount) external;

    function pendingMOT(bytes32 poolName, address _user) external view returns (uint256);
    function withdraw(bytes32 poolName) external;
    function withdrawAll() external;

    event Deposit(address indexed user, bytes32 indexed poolName, uint256 amount);
    event UnDeposit(address indexed user, bytes32 indexed poolName, uint256 amount);
    event Withdraw(address indexed user, bytes32 indexed poolName, uint256 amount);
    event SetMOTPerBlock(uint256 indexed newPerBlock);
    event PoolInfoUpdated(bytes32 indexed poolName, uint256 allocPoint);
}
