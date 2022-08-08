// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Token.sol";
import "src/Exchange.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ContractTest is Test {

    Exchange exchange;
    Token token;
    IERC20 exchangeToken;

    function setUp() public {
        startHoax(address(42), 1000 * 1e18);
        token = new Token("Alchemist", "ALC", 2000 * 1e18);
        exchange = new Exchange(address(token));
        exchangeToken = IERC20(exchange.tokenAddress());
    }

    function testAddLiquidity() public {
        exchangeToken.approve(address(exchange), 200 * 1e18);

        (bool success, ) = address(exchange).call{
            value:100 * 1e18
        }(abi.encodeWithSignature(
            "addLiquidity(uint256)", 
            200 * 1e18)
        );

        assertEq(success, true);
    }

    function testSwap() public {
        testAddLiquidity();
        vm.stopPrank();

        startHoax(address(69), 1000 * 1e18);

        (bool s, ) = address(exchange).call{
            value:10 * 1e18
        }(abi.encodeWithSignature(
            "ethToTokenSwap(uint256)", 
            18 * 1e18)
        );

        assertEq(s, true);
        vm.stopPrank();

    }

    function testRemoveLiquidity() public {
        testSwap();
        vm.startPrank(address(42));
        exchange.removeLiquidity(50 * 1e18);
    }

}












