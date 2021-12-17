module Mazo where

import Carta ( Carta(Carta), PalosCartas(Oro), NumerosCartas(Uno) )

import System.Random
import Data.Array.IO
import Control.Monad ( liftM, forM )
import System.IO
import Data.Array.ST
import Control.Monad.ST ( ST, runST )
import Data.STRef

type Mazo = [Carta]

--Mazo con todas las cartas y sus respectivos palos -- deberian ser 50
nuevoMazo :: Mazo
nuevoMazo = [Carta paloCarta numeroCarta | paloCarta <- [Oro .. ], numeroCarta <- [Uno .. ]]

--funcion para mezclar las cartas
shuffle' :: [a] -> StdGen -> ([a],StdGen)
shuffle' xs gen = runST (do
                g <- newSTRef gen
                let randomRST lohi = do
                            (a,s') <- fmap (randomR lohi) (readSTRef g)
                            writeSTRef g s'
                            return a
                ar <- newArray n xs
                xs' <- forM [1..n] $ \i -> do
                                j <- randomRST (i,n)
                                vi <- readArray ar i
                                vj <- readArray ar j
                                writeArray ar j vi
                                return vj
                gen' <- readSTRef g
                return (xs',gen'))
    where
        n = length xs
        newArray :: Int -> [a] -> ST s (STArray s Int a)
        newArray n =  newListArray (1,n)

shuffleIO :: [a] -> IO [a]
shuffleIO xs = getStdRandom (shuffle' xs)