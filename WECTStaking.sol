// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WECTStaking is Ownable {
    IERC20 public stakingToken;
    IERC20 public rewardToken;
    
    uint256 public rewardRate = 100; // Stel de beloningsrate in (aantal tokens per seconde)
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;
    
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;
    
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    constructor(address _stakingToken, address _rewardToken) Ownable(msg.sender) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Kan geen 0 staken");
        updateReward(msg.sender);
        _totalSupply += _amount;
        _balances[msg.sender] += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Kan geen 0 opnemen");
        require(_balances[msg.sender] >= _amount, "Onvoldoende saldo");
        updateReward(msg.sender);
        _totalSupply -= _amount;
        _balances[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function claimReward() external {
        updateReward(msg.sender);
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "Geen beloningen beschikbaar");
        rewards[msg.sender] = 0;
        rewardToken.transfer(msg.sender, reward);
    }

    function updateReward(address account) internal {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
    }

    function rewardPerToken() public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return rewardPerTokenStored + ((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / _totalSupply;
    }

    function earned(address account) public view returns (uint256) {
        return ((_balances[account] * (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18) + rewards[account];
    }
}