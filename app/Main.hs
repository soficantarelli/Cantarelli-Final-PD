module Main where

import Carta
import Mazo
import Jugada
import Data.Array.IO
import GHC.Base (String)
import Data.String (String)

main :: IO ()
main =  do
    putStrLn "Casita Robada"
    nuevoEstado <- configurar
    putStrLn "A jugar!!!"
    jugar nuevoEstado 1

------------------------------------------------------------------
configurar :: IO EstadoDeJuego
configurar = do
    mazo <- shuffleIO nuevoMazo

    putStrLn "Cual es tu nombre?"
    jugador1 <- nuevoJugador <$> getLine
    let mazo' = repartirNCartas 4 mazo
    let enMano = rep 4 mazo

    --let mazo'' = repartirNCartas 4 mazo'
    --let casita1 = rep 4 mazo'

    let jugador1'' = Jugador (nombre jugador1) enMano []

    putStrLn "Cual es tu nombre?"
    jugador2 <- nuevoJugador <$> getLine
    let mazo''' = repartirNCartas 4 mazo'
    let enMano = rep 4 mazo'

   -- let mazo'''' = repartirNCartas 4 mazo'''
   -- let casita = rep 4 mazo'''

    let jugador2'' = Jugador (nombre jugador2) enMano []

    let mazo'''' = repartirNCartas 4 mazo'''
    let cartasMesa = rep 4 mazo'''

    return (jugador1'', jugador2'', mazo'''', cartasMesa)


jugar :: EstadoDeJuego -> Int -> IO ()
jugar estado@(jugador1, jugador2, mazo, cartasMesa) turno
    | null mazo && noHayAcciones estado = do
         contarCartas estado
    | controlarCartas estado = do
        estado' <- nuevaRonda estado
        jugar estado' turno
    | turno == 1 = do
        cartasPropias jugador1
        putStrLn "\nMesa: "
        print cartasMesa
        texto jugador2
        respuesta <- readLn
        estado' <- elecciones respuesta estado turno
        jugar estado' (turno+1)
    | otherwise = do
        cartasPropias jugador2
        putStrLn "\nMesa: "
        print cartasMesa
        texto jugador1
        respuesta <- readLn
        estado' <- elecciones respuesta estado turno
        jugar estado' (turno-1)