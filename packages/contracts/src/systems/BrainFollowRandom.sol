// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { IWorldCall } from "@latticexyz/world/src/IWorldKernel.sol";
import { Player, PlayerData, PlayerCount, PlayerIndex } from "../codegen/index.sol";
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { IWorld } from "../codegen/world/IWorld.sol";
import { ITick } from "../ITick.sol";
import { PlayerAction } from "../Types.sol";

library test {
  function staticdelegatecall(
    address world,
    address target,
    bytes memory data
  ) internal view returns (bool ok, bytes memory result) {
    (ok, result) = world.staticcall(abi.encodeCall(IWorldCall.staticdelegatecall, (target, data)));
  }
}

using test for address;

contract BrainFollowRandom is System /*, ITick */ {
  address immutable _this = address(this);

  // function tick() external override {
  // This is dumb but it is just to simulate getting a lot of data

  //   (bool ok, bytes memory result) = _world().staticdelegatecall(_this, abi.encodeCall(BrainFollowRandom.getAllPlayers, ()));
  //
  //   require(ok, "BrainFollowRandom: delegatecall failed");
  //
  //   PlayerData[] memory allPlayers = abi.decode(result, (PlayerData[]));
  //
  //   // Choose a random player to follow
  //   uint256 randomIndex = uint256(blockhash(block.number - 1)) % allPlayers.length;
  //
  //   // Use player data to determine action
  //   PlayerData memory thisPlayer;
  //
  //   PlayerData memory target = allPlayers[randomIndex];
  //
  //   PlayerAction action = PlayerAction.NONE;
  //
  //   if (thisPlayer.x < target.x) {
  //     action = PlayerAction.MOVE_RIGHT;
  //   } else if (thisPlayer.x > target.x) {
  //     action = PlayerAction.MOVE_LEFT;
  //   } else if (thisPlayer.y < target.y) {
  //     action = PlayerAction.MOVE_DOWN;
  //   } else if (thisPlayer.y > target.y) {
  //     action = PlayerAction.MOVE_UP;
  //   }
  //
  //   IWorld(_world()).main__run(action);
  // }

  function getAllPlayers() external view returns (PlayerData[] memory) {
    uint256 playerCount = PlayerCount.get();
    PlayerData[] memory allPlayers = new PlayerData[](playerCount);
    for (uint256 i; i < playerCount; i++) {
      bytes32 brainId = PlayerIndex.get(i);
      PlayerData memory data = Player.get(brainId);
      allPlayers[i] = data;
    }
    return allPlayers;
  }
}
