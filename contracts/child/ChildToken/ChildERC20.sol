pragma solidity 0.6.6;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IChildERC20} from "./IChildERC20.sol";
import {AccessControlMixin} from "../../common/AccessControlMixin.sol";
import {NativeMetaTransaction} from "../../common/NativeMetaTransaction.sol";
import {ContextMixin} from "../../common/ContextMixin.sol";


contract ChildERC20 is
    ERC20,
    IChildERC20,
    AccessControlMixin,
    NativeMetaTransaction,
    ContextMixin
{
    bytes32 public constant DEPOSITOR_ROLE = keccak256("DEPOSITOR_ROLE");

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address bridgeHandler
    ) public ERC20(name_, symbol_) {
        _setupContractId("ChildERC20");
        _setupDecimals(decimals_);
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(DEPOSITOR_ROLE, bridgeHandler);
        _initializeEIP712(name_);
    }

    // This is to support Native meta transactions
    // never use msg.sender directly, use _msgSender() instead
    function _msgSender()
        internal
        override
        view
        returns (address payable sender)
    {
        return ContextMixin.msgSender();
    }


    /// @notice Mints the user an amount of this token
    /// @dev Only callable by the bridge handler contract. Intended to be used on a deposit to this chain.
    /// @param user The user to credit
    /// @param amount The amount to mint
    function mint(address user, uint256 amount)
        external
        override
        only(DEPOSITOR_ROLE)
    {
        _mint(user, amount);
    }

    /// @notice Burns the user's tokens
    /// @dev Only callable by the bridge handler contract. Intended to be use on a withdraw from this chain.
    /// @param user The user whose tokens to burn
    /// @param amount The amount to mint
    function burnFrom(address user, uint256 amount)
        external
        override
        only(DEPOSITOR_ROLE)
    {
        _burn(user, amount);
    }
}
