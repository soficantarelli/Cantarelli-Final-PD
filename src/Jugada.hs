module Jugada where

import Carta
import Mazo
import Data.List
import Data.Ord


type Mesa = [Carta]

data Jugador = Jugador { nombre :: String, enMano :: [Carta], casita ::[Carta]} deriving (Show)

type EstadoDeJuego = (Jugador, Jugador, Mazo, Mesa)

-- Jugador
nuevoJugador :: String -> Jugador
nuevoJugador nombre = Jugador nombre [] []

--Jugada 1: repartir cartas tanto a jugador como en la mesa

repartir :: Mazo -> (Carta, Mazo)
repartir [] = error "Mazo Vacio"
repartir (x:xs) = (x, xs)

repartirCarta :: Mazo -> Mazo
repartirCarta [] = error "Mazo Vacio"
repartirCarta m =  let (carta, m') = repartir m
                                    in m'

repartirNCartas :: Int -> Mazo -> Mazo
repartirNCartas n m
    | n > length m  = error "No hay cartas suficientes"
    | n < 1         = error "Debes repartir por lo menos 1 carta"
    | n == 1        = repartirCarta m
    | otherwise     = repartirNCartas (n - 1) m'
        where m' = repartirCarta m

--saco las cartas usadas
rep :: Int -> Mazo -> [Carta]
rep = take

-----------------------------------------------

--Puede tomar cartas hasta que diga que pasa
--controlar que sea del mismo numero o palo
tomarCartaMesa :: EstadoDeJuego -> Int -> IO EstadoDeJuego
tomarCartaMesa (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa) turno
    | turno == 1 = do

        putStrLn $ "\nCartas en mesa: " ++ show cartasMesa
        putStrLn $ "\nTu mano: " ++ show enMano1
        putStrLn "Elegí una carta a usar"
        n <- readLn
        let (enMano1', cartaAUsar) = obtenerCarta enMano1 n

        putStrLn "Elegí carta a levantar"
        m <- readLn
        let (cartasMesa', cartaALevantar) = obtenerCartaMesa cartasMesa m

        unirCartas (compararCartasMesa cartaALevantar cartaAUsar) (Jugador nombre1 enMano1' casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa') turno cartaAUsar cartaALevantar 1

    | otherwise = do
        putStrLn $ "\nCartas en mesa: " ++ show cartasMesa
        putStrLn $ "\nTu mano: " ++ show enMano2
        putStrLn "Elegí una carta a usar"
        n <- readLn
        let (enMano2', cartaAUsar) = obtenerCarta enMano2 n

        putStrLn "Elegí carta a levantar"
        m <- readLn
        let (cartasMesa', cartaALevantar) = obtenerCartaMesa cartasMesa m

        unirCartas (compararCartasMesa cartaALevantar cartaAUsar) (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2' casita2,  mazo, cartasMesa') turno cartaAUsar cartaALevantar 1

--pasar arrlego y armar mesa despues
obtenerCartaMesa :: Mesa -> Int -> ([Carta], [Carta])
obtenerCartaMesa cartasEnMesa n = let c = cartasEnMesa !! (n - 1) in (cartasEnMesa \\ [c], [c])


compararCartasMesa :: [Carta] -> [Carta] -> Bool
compararCartasMesa [Carta pc2 nc2] [Carta pc1 nc1] = mismoPalo || mismoNumero
    where
        mismoPalo = pc2 == pc1
        mismoNumero = nc2 == nc1

--Puede tomar la casita del otro
--controlar que sea del mismo numero o palo
robarCasita :: EstadoDeJuego -> Int -> IO EstadoDeJuego
robarCasita (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa) turno
    | turno == 1 = do

        let cartaAuxCasitaOponente = cartasEnCasitaOponente casita2
        putStrLn $ "\nCarta casita oponente: " ++ show cartaAuxCasitaOponente
        putStrLn $ "\nTu mano: " ++ show enMano1
        putStrLn "Elegí una carta con la cual robar la casita"
        n <- readLn
        let (enMano1', cartaAUsar) = obtenerCarta enMano1 n
        unirCartas (compararCartas cartaAuxCasitaOponente cartaAUsar) (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa) turno cartaAUsar enMano1' 2

    | otherwise = do

        let cartaAuxCasitaOponente = cartasEnCasitaOponente casita1
        putStrLn $ "\nCarta casita oponente: " ++ show cartaAuxCasitaOponente
        putStrLn $ "\nTu mano: " ++ show enMano2
        putStrLn "Elegí una carta con la cual robar la casita"
        n <- readLn
        let (enMano2', cartaAUsar) = obtenerCarta enMano2 n
        unirCartas (compararCartas cartaAuxCasitaOponente cartaAUsar) (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa) turno cartaAUsar enMano2' 2


unirCartas :: Bool -> EstadoDeJuego -> Int -> [Carta] -> [Carta] -> Int -> IO EstadoDeJuego
unirCartas aux (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa) turno cartaAUsar cartaAux jugada
    | aux && turno == 1 && jugada == 2 = do
        let casita1' = cartasEnCasita cartaAUsar casita1 casita2
        return (Jugador nombre1 cartaAux casita1', Jugador nombre2 enMano2 [], mazo, cartasMesa)
    | aux && turno == 2 && jugada == 2 = do
        let casita2' = cartasEnCasita cartaAUsar casita1 casita2 
        return (Jugador nombre1 enMano1 [], Jugador nombre2 cartaAux casita2', mazo, cartasMesa)
    | aux && turno == 1 && jugada == 1 = do
        let casita1' = cartasEnCasita cartaAUsar cartaAux casita1
        return (Jugador nombre1 enMano1 casita1', Jugador nombre2 enMano2 casita2, mazo, cartasMesa)
    | aux && turno == 2 && jugada == 1 = do
        let casita2' = cartasEnCasita cartaAUsar cartaAux casita2 
        return (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2', mazo, cartasMesa)
    | otherwise = do
        return (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa)       

--uno todas las cartas para formar mi casita nueva
cartasEnCasita :: [Carta] -> [Carta] -> [Carta] -> [Carta]
cartasEnCasita cartaAUsar casitaPropia casitaOponente = cartaAUsar ++ casitaPropia ++ casitaOponente

--comparo si es igual el palo o el numero para saber si puedo robarme la casita del otro
compararCartas :: Carta -> [Carta] -> Bool
compararCartas (Carta pc2 nc2) [Carta pc1 nc1] = mismoPalo || mismoNumero
    where
        mismoPalo = pc2 == pc1
        mismoNumero = nc2 == nc1

--cartasEnCasitaOponente casitaOponente = head casitaOponente
cartasEnCasitaOponente :: [Carta] -> Carta
cartasEnCasitaOponente = head

--saco la carta que voy a usar
obtenerCarta :: [Carta] -> Int -> ([Carta], [Carta])
obtenerCarta enMano n = let c = enMano !! (n - 1) in (enMano \\ [c], [c])


--Si no tiene para levantar debe tirar una carta
--esta opcion va por defecto en el caso de ingresar cualquier numero
tirarCarta :: EstadoDeJuego -> Int -> IO EstadoDeJuego
tirarCarta (Jugador nombre enMano casita, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa) turno
    | turno == 1 = do
        putStrLn $ "\nTu mano: " ++ show enMano
        putStrLn "Elegí una carta a descartar"
        n <- readLn
        let (enMano', cartasMesa') = tirarCartaEnMesa enMano n cartasMesa
        return (Jugador nombre enMano' casita, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa')
    | otherwise = do
        putStrLn $ "\nTu mano: " ++ show enMano2
        putStrLn "Elegí una carta a descartar"
        n <- readLn
        let (enMano2', cartasMesa') = tirarCartaEnMesa enMano2 n cartasMesa
        return (Jugador nombre enMano casita, Jugador nombre2 enMano2' casita2,  mazo, cartasMesa')


tirarCartaEnMesa :: [Carta] -> Int -> [Carta] -> ([Carta], Mazo)
tirarCartaEnMesa mano n mesa = let c = mano !! (n - 1) in (mano \\ [c], c:mesa)


--Una vez finalizadas las rondas hay que repartir nuevamente las cartas

controlarCartas :: EstadoDeJuego -> Bool
controlarCartas (Jugador nombre enMano1 casita, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa)
    | null enMano1 && null enMano2 = True
    | otherwise = False


nuevaRonda :: EstadoDeJuego -> IO EstadoDeJuego
nuevaRonda (Jugador nombre enMano1 casita, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa) = do

    let mazo' = repartirNCartas 4 mazo
    let enMano1 = rep 4 mazo

    let mazo'' = repartirNCartas 4 mazo'
    let enMano2' = rep 4 mazo'

    let mazo''' = repartirNCartas 4 mazo''
    let cartasMesa' = rep 4 mazo''

    return (Jugador nombre enMano1 casita, Jugador nombre2 enMano2' casita2,  mazo''', cartasMesa' ++ cartasMesa)

------------------------------------------------------------------
noHayAcciones :: EstadoDeJuego -> Bool
noHayAcciones (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa)
    | null enMano1 && null enMano2 = True
    | otherwise = False

------------------------------------------------

contarCartas :: EstadoDeJuego -> IO()
contarCartas (Jugador nombre1 enMano1 casita1, Jugador nombre2 enMano2 casita2,  mazo, cartasMesa) = do
    if length casita1 > length casita2
        then
            putStrLn ("Felicitaciones " ++ nombre1)
        else
            putStrLn ("Felicitaciones " ++ nombre2)
    putStrLn "Gracias por jugar"

------------------------------------------------
texto :: Jugador -> IO ()
texto (Jugador nombre enMano casita) = do

    if null casita
        then
            putStrLn "\nCasita Oponente vacia"

        else do
            let x = cartasEnCasitaOponente casita
            putStrLn "\nCasita Oponente: "
            print x

    putStrLn "\nIngrese número de accion: "
    putStrLn "\n 1) Tomar una carta de la mesa "
    putStrLn "\n 2) Robar casita del oponente "
    putStrLn "\n 3) Tirar carta y pasar "


cartasPropias :: Jugador -> IO ()
cartasPropias (Jugador nombre enMano casita)= do
    putStrLn "\n----------------------------------------------"
    putStrLn "Jugador: "
    print nombre
    putStrLn "Tus cartas: "
    print enMano


elecciones :: Int -> EstadoDeJuego -> Int -> IO EstadoDeJuego
elecciones resp estado turno 
    | resp == 1 = do
        tomarCartaMesa estado turno
    | resp == 2 = do
        robarCasita estado turno
    | otherwise = do
        tirarCarta estado turno