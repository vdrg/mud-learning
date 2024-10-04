// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { IWorld } from "../codegen/world/IWorld.sol";
import { Player, PlayerData, PlayerCount } from "../codegen/index.sol";
import { PlayerAction } from "../Types.sol";

uint256 constant MAP_SIZE = 100;

function initPlayerData(System brain) pure returns (PlayerData memory) {
  // not really random
  uint256 randomX = uint256(keccak256(abi.encodePacked(brain))) % MAP_SIZE;
  uint256 randomY = uint256(keccak256(abi.encodePacked(randomX))) % MAP_SIZE;
  return PlayerData({ x: randomX, y: randomY });
}

contract PlayerSystem is System {
  function spawn(bytes14 namespace, bytes16 name, System brain) public returns (ResourceId) {
    ResourceId namespaceId = WorldResourceIdLib.encodeNamespace(namespace);
    ResourceId systemId = WorldResourceIdLib.encode({ typeId: RESOURCE_SYSTEM, namespace: namespace, name: name });

    IWorld world = IWorld(_world());

    // Register the namespace
    // TODO: check unique namespace?
    world.registerNamespace(namespaceId);

    // Register the System
    world.registerSystem(systemId, brain, true);

    // TODO: make the system private and grant access only from the tick system?
    // Otherwise the tick function in the brain can be called multiple times per block
    // world.registerSystem(systemId, brain, false);

    Player.set(ResourceId.unwrap(systemId), initPlayerData(brain));
    PlayerCount.set(PlayerCount.get() + 1);

    return systemId;
  }

  function run(PlayerAction action) external {
    // TODO: check the sender's resource id somehow
    ResourceId brainId = SystemRegistry.get(_msgSender());

    // TODO: not sure about this
    require(ResourceId.unwrap(brainId) != 0, "Invalid sender");

    PlayerData memory data = Player.get(ResourceId.unwrap(brainId));

    if (action == PlayerAction.NONE) {
      return;
    }

    if (action == PlayerAction.MOVE_UP && data.y > 0) {
      data.y -= 1;
    } else if (action == PlayerAction.MOVE_RIGHT && data.x < MAP_SIZE - 1) {
      data.x += 1;
    } else if (action == PlayerAction.MOVE_DOWN && data.y < MAP_SIZE - 1) {
      data.y += 1;
    } else if (action == PlayerAction.MOVE_LEFT && data.x > 0) {
      data.x -= 1;
    }

    Player.set(ResourceId.unwrap(brainId), data);
  }
}
