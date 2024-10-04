import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "main",
  tables: {
    Player: {
      schema: {
        brainId: "bytes32", // This will actually point to the specific brain system
        x: "uint256",
        y: "uint256",
        // updatedAt: "uint256",
      },
      key: ["brainId"],
    },
    PlayerIndex: {
      schema: {
        index: "uint256",
        brainId: "bytes32",
      },
      key: ["index"],
    },
    PlayerCount: {
      schema: {
        value: "uint256",
      },
      key: []
    },
    Tick: {
      schema: {
        systemId: "bytes32", // Resource Id
        updatedAt: "uint256", // For now, each tick can be called at most once per block
      },
      key: ["systemId"],
    },
  },
});
