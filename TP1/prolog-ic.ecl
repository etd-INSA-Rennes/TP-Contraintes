:- lib(ic).

voiture(rouge).
voiture(vert(clair)).
voiture(gris).
voiture(blanc).
bateau(vert).
bateau(blanc).
bateau(noir).

/**
 * Question 1.1
 * choixCouleur(?CouleurBateau, ?CouleurVoiture)
 */
choixCouleur(Couleur, Couleur):-
	voiture(Couleur),
	bateau(Couleur).


minResistance(5000).
maxResistance(10000).
minCondensateur(9000).
maxCondensateur(20000).

/**
 * Question 1.3
 * isBetween(?Var, +Min, -Max)
 */
isBetween(Var, Min, Max):-
	not(free(Var)),
	Var >= Min,
	Var =< Max.
isBetween(Var, Min, Max):-
	free(Var),
	isBetweenIncremental(Var, Min, Max).

/**
 * isBetweenIncremental(-Var, +Min, +Max)
 */
isBetweenIncremental(Min, Min, Max).
isBetweenIncremental(Var, Min, Max):-
	NextMin is Min + 1,
	NextMin =< Max,
	isBetweenIncremental(Var, NextMin, Max).

/**
 * Question 1.4
 * commande(-NbResistances, -NbCondensateurs)
 */
commande(NbResistances, NbCondensateurs):-
	isBetween(NbResistances, 5000, 10000),
	isBetween(NbCondensateurs, 9000, 20000),
	NbResistances > NbCondensateurs.

/**
 * Question 1.7
 * commandeIC(-NbResistances, -NbCondensateurs)
 */
commandeIC(NbResistances, NbCondensateurs):-
	NbResistances #:: 5000..10000,
	NbCondensateurs #:: 9000..20000,
	NbResistances #> NbCondensateurs.

/**
 * Question 1.8
 * commandeLabeling(-NbResistances, -NbCondensateurs)
 */
commandeLabeling(NbResistances, NbCondensateurs):-
	commandeIC(NbResistances, NbCondensateurs),
	labeling([NbResistances, NbCondensateurs]).


/**
 * Tests
 *//*
choixCouleur(blanc, blanc). => Yes
choixCouleur(noir, vert(clair)). => No
choixCouleur(vert, vert(clair)). => No
choixCouleur(CouleurBateau, CouleurVoiture).
	CouleurBateau = blanc
	CouleurVoiture = blanc
	Yes (0.00s cpu)

isBetween(4000000, 1000000, 8000000). => Yes
isBetween(10000000, 1000000, 8000000). => No
isBetween(X, 1, 3).
	X = 1
	Yes (0.00s cpu, solution 1, maybe more)
	X = 2
	Yes (0.00s cpu, solution 2, maybe more)
	X = 3
	Yes (0.00s cpu, solution 3, maybe more)
	No (0.00s cpu)

findall((NbResistances, NbCondensateurs), commande(NbResistances, NbCondensateurs), Results), length(Results, NbResults). => 500500
commandeIC(NbResistances, NbCondensateurs).
	NbResistances = NbResistances{9001 .. 10000}
	NbCondensateurs = NbCondensateurs{9000 .. 9999}
	Delayed goals:
		-(NbCondensateurs{9000 .. 9999}) + NbResistances{9001 .. 10000} #> 0
findall((NbResistances, NbCondensateurs), commandeLabeling(NbResistances, NbCondensateurs), Results), length(Results, NbResults). => 500500*/