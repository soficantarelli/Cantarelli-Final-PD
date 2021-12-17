module Carta where

--Valor numerico de la carta
data NumerosCartas = Uno 
                    | Dos 
                    | Tres 
                    | Cuatro 
                    | Cinco
                    | Seis 
                    | Siete 
                    | Ocho 
                    | Nueve 
                    | Diez
                    | Once 
                    | Doce
                deriving (Show, Enum, Eq)

--Valor Palos de la carta
data PalosCartas = Oro 
                | Copa 
                | Espada 
                | Basto
            deriving (Enum, Eq)

--Una carta está conformada por un numero y un paloCarta
data Carta = Carta { paloCarta :: PalosCartas
                    ,numeroCarta :: NumerosCartas }
        deriving (Eq)


instance Show PalosCartas where
    show Oro = "O"
    show Copa = "C"
    show Espada = "E"
    show Basto = "B"


instance Show Carta where
    show (Carta paloCarta Uno) = "1" ++ show paloCarta
    show (Carta paloCarta Dos) = "2" ++ show paloCarta
    show (Carta paloCarta Tres) = "3" ++ show paloCarta
    show (Carta paloCarta Cuatro) = "4" ++ show paloCarta
    show (Carta paloCarta Cinco) = "5" ++ show paloCarta
    show (Carta paloCarta Seis) = "6" ++ show paloCarta
    show (Carta paloCarta Siete) = "7" ++ show paloCarta
    show (Carta paloCarta Ocho) = "8" ++ show paloCarta
    show (Carta paloCarta Nueve) = "9" ++ show paloCarta
    show (Carta paloCarta Diez) = "10" ++ show paloCarta
    show (Carta paloCarta Once) = "11" ++ show paloCarta
    show (Carta paloCarta Doce) = "12" ++ show paloCarta