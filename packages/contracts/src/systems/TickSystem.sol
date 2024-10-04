// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ResourceIds } from "@latticexyz/store/src/codegen/index.sol";
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { Tick } from "../codegen/index.sol";
import { IWorld } from "../codegen/world/IWorld.sol";
import { ITick } from "../ITick.sol";

contract TickSystem is System {
  function registerTick(ResourceId systemId) external {
    require(systemId.getType() == RESOURCE_SYSTEM, "Invalid resource type");
    require(ResourceIds.getExists(systemId), "Resource doesn't exist");

    bytes32 id = ResourceId.unwrap(systemId);

    require(Tick.get(id) == 0, "System already registered in tick system");
    Tick.set(id, block.number);
  }

  function tick(ResourceId[] calldata systemIds) external {
    for (uint256 i = 0; i < systemIds.length; i++) {
      ResourceId systemId = systemIds[i];
      uint256 updatedAt = Tick.getUpdatedAt(ResourceId.unwrap(systemId));
      if (updatedAt == 0 || updatedAt >= block.number) {
        continue;
      }

      // TODO: use return data?
      IWorld(_world()).call(systemId, abi.encodeCall(ITick.tick, ()));
    }
  }
}
