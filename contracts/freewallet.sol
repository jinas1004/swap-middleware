// SPDX-License-Identifier: FREEMETA
pragma solidity 0.8.4;

interface IFreeWallet {
    function swapExactTokensForTokensToDex(
        uint amountIn, 
        uint amountOutMin, 
        address[] calldata path, 
        address to, 
        uint deadline, 
        address router
    ) external;
/*
    function transferFromToDexAbi(
        address erc20,
        uint amount
    ) external;

    function transferFromToDexFunc(
        address erc20,
        uint amount
    ) external;
*/
}

interface IDex {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IBEP20 {
  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function getOwner() external view returns (address);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address _owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeApprove: approve failed'
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeTransfer: transfer failed'
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::transferFrom: transferFrom failed'
        );
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
    }
}

contract FreeWallet is IFreeWallet {
    function swapExactTokensForTokensToDex(
        uint amountIn, 
        uint amountOutMin, 
        address[] calldata path, 
        address to, 
        uint deadline, 
        address router
    ) external override {
        IBEP20(path[0]).transferFrom(msg.sender, address(this), amountIn);

        // 받은 돈을 수수료로 떼는 로직이 있다고 가정

        IBEP20(path[0]).approve(router, amountIn);
        IDex(router).swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline);
    }
/*
    function transferFromToDexAbi(
        address erc20,
        uint amount
    ) external override {
        (bool success, ) = erc20.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), amount));
        require(success, "transferFrom tx failed");
    }

    function transferFromToDexFunc(
        address erc20,
        uint amount
    ) external override {
        IBEP20(erc20).transferFrom(msg.sender, address(this), amount);
    }
*/
}
