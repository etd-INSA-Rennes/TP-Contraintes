:- lib(ic).

/**
 * chapieBug(-Chats, -Pies, -Pattes, -Tetes)
 * chapie tourne dans le vide a partir de la seconde solution pour la question 1.10.
 */
chapieBug(Chats, Pies, Pattes, Tetes):-
	Chats #:: 0..inf,
	Pies #:: 0..inf,
	Pattes #:: 0..inf,
	Tetes #:: 0..inf,
	Pattes #= Chats * 4 + Pies * 2,
	Tetes #= Chats + Pies.

/**
 * chapie(-Chats, -Pies, -Pattes, -Tetes)
 */
chapie(Chats, Pies, Pattes, Tetes):-
	Chats #:: 0..1000,
	Pies #:: 0..1000,
	Pattes #:: 0..1000,
	Tetes #:: 0..1000,
	Pattes #= Chats * 4 + Pies * 2,
	Tetes #= Chats + Pies.

/**
 * Question 1.9
 */
chapie(2, Pies, Pattes, 5).
	Pies = 3
	Pattes = 14
	Yes (0.00s cpu)

/**
 * Question 1.10
 */
chapie(Chats, Pies, Pattes, Tetes), Pattes #= 3 * Tetes.
	Chats = Chats{0 .. 249}
	Pies = Pies{0 .. 333}
	Pattes = Pattes{0 .. 999}
	Tetes = Tetes{0 .. 333}
	Delayed goals:
	        Pattes{0 .. 999} - 2 * Pies{0 .. 333} - 4 * Chats{0 .. 249} #= 0
	        Tetes{0 .. 333} - Pies{0 .. 333} - Chats{0 .. 249} #= 0
	        -3 * Tetes{0 .. 333} + Pattes{0 .. 999} #= 0
	Yes (0.00s cpu)

chapie(Chats, Pies, Pattes, Tetes), Pattes #= 3 * Tetes, labeling([Chats, Pies, Pattes, Tetes]).
	Chats = 0
	Pies = 0
	Pattes = 0
	Tetes = 0
	Yes (0.00s cpu, solution 1, maybe more)
	Chats = 1
	Pies = 1
	Pattes = 6
	Tetes = 2
	Yes (0.00s cpu, solution 2, maybe more)
	... (167 solutions avec des limites à 1000)