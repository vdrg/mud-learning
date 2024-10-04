import React, { useEffect, useState, useRef } from 'react';
import { useEntityQuery } from "@latticexyz/react";
import { Has, getComponentValueStrict } from "@latticexyz/recs";
import { useMUD } from "./MUDContext";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { MapPin } from "lucide-react";

const CoordinateValue = ({ value, label, isChanged }) => (
  <span className={`inline-block transition-all duration-500 ${isChanged ? 'text-green-600 scale-110' : ''}`}>
    {label}: {value}
  </span>
);

const PlayerComponent = React.memo(({ x, y, playerIndex }: { x: number, y: number, playerIndex: number }) => {
  const [isAnimating, setIsAnimating] = useState(false);
  const prevX = useRef(x);
  const prevY = useRef(y);
  const [xChanged, setXChanged] = useState(false);
  const [yChanged, setYChanged] = useState(false);

  useEffect(() => {
    if (x !== prevX.current || y !== prevY.current) {
      setIsAnimating(true);
      setXChanged(x !== prevX.current);
      setYChanged(y !== prevY.current);
      const timer = setTimeout(() => {
        setIsAnimating(false);
        setXChanged(false);
        setYChanged(false);
      }, 500);
      prevX.current = x;
      prevY.current = y;
      return () => clearTimeout(timer);
    }
  }, [x, y]);

  return (
    <Card className={`mb-4 transition-colors duration-500 ${isAnimating ? 'bg-green-100' : ''} w-64`}>
      <CardHeader className="flex flex-row items-center justify-between pb-2">
        <h2 className="text-lg font-bold">Player  {playerIndex + 1}</h2>
        <MapPin className="h-5 w-5 text-gray-500" />
      </CardHeader>
      <CardContent>
        <p className="text-sm text-gray-600">Coordinates:</p>
        <p className="text-lg font-semibold space-x-4">
          <CoordinateValue value={x} label="X" isChanged={xChanged} />
          <CoordinateValue value={y} label="Y" isChanged={yChanged} />
        </p>
      </CardContent>
    </Card>
  );
});

export const App = () => {
  const {
    components: { Player },
  } = useMUD();

  const players = useEntityQuery([Has(Player)]);

  const playerData = players.map((player) => {
    const { x, y } = getComponentValueStrict(Player, player);
    return { id: player, x: Number(x), y: Number(y) };
  });

  console.log('App rendering, players:', players.length);

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Players</h1>
      <div className="flex flex-wrap gap-4">
        {playerData.map(({ id, x, y }, i) => (
          <PlayerComponent key={id} playerIndex={i} x={x} y={y} />
        ))}
      </div>
    </div>
  );
};

export default App;
