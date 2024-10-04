// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { Player, PlayerData } from "../codegen/index.sol";
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { IWorld } from "../codegen/world/IWorld.sol";
import { ITick } from "../ITick.sol";
import { PlayerAction } from "../Types.sol";

contract BrainRandom is System, ITick {
  function tick() external override {
    // Call the PlayerSystem with a random action
    PlayerAction action = PlayerAction(uint8(uint256(blockhash(block.number - 1))) % 5);

    IWorld(_world()).main__run(action);
  }
}
