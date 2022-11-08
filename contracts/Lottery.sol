// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 0.1 ether, "ether sent is below minimum required");
        players.push(msg.sender);
    }

    function random() private view returns (uint256) {
                return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    }

    function pickWinner() public {
        require(msg.sender == manager);
        uint256 index = random() % players.length;
        (bool sent,) = payable(players[index]).call{value: address(this).balance} ("");
        require(sent, "Ether not sent");
        players = new address[](0);
    }
}