// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title KOLO Crowdsale
 * @notice Allows users to purchase KOLO tokens by sending POL tokens (formerly MATIC).
 * @dev This contract should be deployed separately from the main KOLOCASH token contract.
 */
contract KoloCrowdsale is Ownable {
    IERC20 public koloToken; // KOLO token being sold
    uint256 public rate; // How many KOLO tokens a buyer gets per POL
    bool public saleActive; // Status of the Crowdsale

    event TokensPurchased(
        address indexed buyer,
        uint256 polAmount,
        uint256 koloAmount
    );

    /**
     * @dev Constructor sets the KOLO token address and initial exchange rate.
     * @param _koloToken Address of the KOLO ERC20 token
     * @param _rate Number of KOLO tokens per POL token
     */
    constructor(address _koloToken, uint256 _rate) Ownable(msg.sender) {
        require(_rate > 0, "Rate must be greater than zero");
        koloToken = IERC20(_koloToken);
        rate = _rate;
        saleActive = true;
    }

    /**
     * @notice Receive function to handle direct POL transfers to the contract
     */
    receive() external payable {
        buyTokens();
    }

    /**
     * @notice Public function to purchase KOLO tokens by sending POL
     */
    function buyTokens() public payable {
        require(saleActive, "Crowdsale is currently inactive");
        require(msg.value > 0, "You must send some POL to purchase KOLO");

        uint256 koloAmount = msg.value * rate;
        require(
            koloToken.balanceOf(address(this)) >= koloAmount,
            "Not enough KOLO tokens available in Crowdsale"
        );

        koloToken.transfer(msg.sender, koloAmount);
        emit TokensPurchased(msg.sender, msg.value, koloAmount);
    }

    /**
     * @notice Withdraw collected POL funds to the owner's wallet
     */
    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    /**
     * @notice Withdraw unsold KOLO tokens back to the owner's wallet after Crowdsale
     */
    function withdrawUnsoldTokens() external onlyOwner {
        uint256 remainingKolo = koloToken.balanceOf(address(this));
        require(remainingKolo > 0, "No KOLO tokens remaining");
        koloToken.transfer(owner(), remainingKolo);
    }

    /**
     * @notice Activate or deactivate the Crowdsale
     * @param _active Boolean to activate (true) or deactivate (false)
     */
    function setSaleActive(bool _active) external onlyOwner {
        saleActive = _active;
    }

    /**
     * @notice Adjust the exchange rate of KOLO tokens per POL
     * @param _newRate The new rate for KOLO/POL
     */
    function setRate(uint256 _newRate) external onlyOwner {
        require(_newRate > 0, "Rate must be greater than zero");
        rate = _newRate;
    }
}
