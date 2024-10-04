import { useEntityQuery } from "@latticexyz/react";
import { Has, HasValue, getComponentValueStrict } from "@latticexyz/recs";
import { useMUD } from "./MUDContext";

interface PlayerComponentProps {
  x: bigint;
  y: bigint;
}

const PlayerComponent: React.FC<PlayerComponentProps> = ({ x, y }) => (
  <div>(x: {Number(x)}, y: {Number(y)})</div>
);

export const App = () => {
  const {
    components: { Tick, Player },
    systemCalls: { },
  } = useMUD();

  const players = useEntityQuery([Has(Player)])
  return (
    <>
      <div>
        <h1>Players</h1>
        {players.map((player, index) => {
          const playerData = getComponentValueStrict(Player, player);
          return (
            <div>
              <PlayerComponent
                key={index}
                x={playerData.x}
                y={playerData.y}
              />
            </div>
          );
        })}
      </div>
    </>
  );

};
