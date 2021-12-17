Introducción
Para el trabajo final desarrolle un juego de cartas llamado “Casita Robada” en Haskell; el mismo permite la utilización de las cartas tanto como por sus números como por sus palos.

Desarrollo
El juego utiliza la baraja española sin los comodines teniendo un total de 48 cartas y se juega de a dos usuarios. Gana el usuario que tengas más cartas en la casita.
Al comienzo del juego se reparten cuatro cartas a cada jugador y se colocan cuatro cartas sobre la mesa, además, las casitas comienzan vacías. Luego cada jugador tendrá su turno para realizar diferentes acciones:
1.	Tomar una carta de la mesa
2.	Robar la casita del oponente
3.	Tirar carta y pasar
Tomar una carta de la mesa, el jugador elige una carta que tiene en la mano para poder levantar una carta de la mesa; las cartas deben tener o el mismo palo o el mismo número.
Robar la casita del oponente, el jugador a través de una carta que tenga o el mismo palo o el mismo número podrá sacarle la pila de cartas del oponente y quedárselas.
Tirar carta y pasar, se realiza la acción al no tener una carta coincidente para alguna de las opciones anteriores, por lo tanto, el usuario decide que carta va a colocar sobre la mesa.
Una vez que los jugadores se quedan sin cartas en mano, se vuelven a repartir otras cuatro para cada uno y se agregan nuevamente cuatro a le mesa. Se realiza está acción hasta terminar todas las cartas del mazo. 
Finalmente se cuentan las cartas de las casitas y gana el jugador que obtuvo mayoría de cartas. 
