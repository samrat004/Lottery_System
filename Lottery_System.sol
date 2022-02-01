// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottry {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 2 ether);
        players.push(payable(msg.sender));
    }

    function getBalence() public view returns (uint256) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    function selectWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);
        uint256 ran = random();
        uint256 index = ran % players.length;
        address payable winner;
        winner = players[index];
        winner.transfer(getBalence());
        players = new address payable[](0);
    }
}
