// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { BrainRandom } from "../src/systems/BrainRandom.sol";

import { NUMBER_OF_BRAINS, encodeBrainNamespace } from "./Util.sol";

contract Tick is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    IWorld world = IWorld(worldAddress);

    ResourceId[] memory ids = new ResourceId[](NUMBER_OF_BRAINS);
    // Spawn a few brainssss
    for (uint8 i; i < NUMBER_OF_BRAINS; i++) {
      // unique namespace for each brain
      bytes14 namespace = encodeBrainNamespace(i);
      ids[i] = WorldResourceIdLib.encode({ typeId: RESOURCE_SYSTEM, namespace: namespace, name: "brain" });
    }

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    // Register the brain system in the Tick system
    world.main__tick(ids);

    vm.stopBroadcast();
  }
}
