// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { BrainRandom } from "../src/systems/BrainRandom.sol";

import { NUMBER_OF_BRAINS, encodeBrainNamespace } from "./Util.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    IWorld world = IWorld(worldAddress);

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    // ------------------ EXAMPLES ------------------

    // Spawn a few brainssss
    for (uint256 i; i < NUMBER_OF_BRAINS; i++) {
      BrainRandom brain = new BrainRandom();
      // unique namespace for each brain
      bytes14 namespace = encodeBrainNamespace(i);
      ResourceId systemId = world.main__spawn(namespace, "brain", brain);

      // Register the brain system in the Tick system
      world.main__registerTick(systemId);
    }

    vm.stopBroadcast();
  }
}
