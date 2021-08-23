pragma solidity 0.6.6;

abstract contract IChildERC20 {
    function mint(address user, uint256 amount) external virtual;
    function burnFrom(address user, uint256 amount) external virtual; 
}