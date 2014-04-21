:- lib(ic_symbolic).
:- lib(ic).

/**
 * Question 2.1
 */
:- local domain(pays(angleterre, espagne, ukraine, norvege, japon)).
:- local domain(couleur(rouge, vert, jaune, bleu, blanc)).
:- local domain(boisson(cafe, the, lait, jus_orange, eau)).
:- local domain(voiture(bmw, toyota, ford, honda, datsun)).
:- local domain(animal(chien, serpent, renard, cheval, zebre)).

/**
 * Question 2.2
 * domaines_maison(?Maison)
 */
domaines_maison(m(Pays, Couleur, Boisson, Voiture, Animal, _)):-
	Pays &:: pays,
	Couleur &:: couleur,
	Boisson &:: boisson,
	Voiture &:: voiture,
	Animal &:: animal.

/**
 * Question 2.3
 * rue(?Rue)
 */
rue([M1, M2, M3, M4, M5]):-
	M1 = m(P1, C1, B1, V1, A1, 1),
	M2 = m(P2, C2, B2, V2, A2, 2),
	M3 = m(P3, C3, B3, V3, A3, 3),
	M4 = m(P4, C4, B4, V4, A4, 4),
	M5 = m(P5, C5, B5, V5, A5, 5),
	domaines_maison(M1),
	domaines_maison(M2),
	domaines_maison(M3),
	domaines_maison(M4),
	domaines_maison(M5),
	ic_symbolic:alldifferent([P1, P2, P3, P4, P5]),
	ic_symbolic:alldifferent([C1, C2, C3, C4, C5]),
	ic_symbolic:alldifferent([B1, B2, B3, B4, B5]),
	ic_symbolic:alldifferent([V1, V2, V3, V4, V5]),
	ic_symbolic:alldifferent([A1, A2, A3, A4, A5]).

/**
 * Question 2.4
 * ecrit_maisons(?Rue)
 */
ecrit_maisons(Rue):-
	(foreach(m(Pays, Couleur, Boisson, Voiture, Animal, Numero), Rue)
	do
		write(Pays), write(" "),
		write(Couleur), write(" "),
		write(Boisson), write(" "),
		write(Voiture), write(" "),
		write(Animal), write(" "),
		write(Numero), write(" "),
		nl
	).

/**
 * Question 2.5
 * getVarList(?Rue, ?Liste)
 */
getVarList([], []).
getVarList([m(Pays, Couleur, Boisson, Voiture, Animal, _)|Rue], [Pays, Couleur, Boisson, Voiture, Animal|Liste]):-
	getVarList(Rue, Liste).

/**
 * labeling_symbolic(+Liste)
 */
labeling_symbolic([]).
labeling_symbolic([Var|Liste]):-
	ic_symbolic:indomain(Var),
	labeling_symbolic(Liste).

/**
 * Question 2.6 & 2.7
 * resoudre
 */
resoudre:-
	rue(Rue),

	(foreach(m(Pays, Couleur, Boisson, Voiture, Animal, Numero), Rue)
	do
		((Pays &= angleterre) #= (Couleur &= rouge)) and
		((Pays &= espagne) #= (Animal &= chien)) and
		((Couleur &= vert) #= (Boisson &= cafe)) and
		((Pays &= ukraine) #= (Boisson &= the)) and
		((Voiture &= bmw) #= (Animal &= serpent)) and
		((Couleur &= jaune) #= (Voiture &= toyota)) and
		((Boisson &= lait) #= (Numero #= 3)) and
		((Pays &= norvege) #= (Numero #= 1)) and
		((Voiture &= honda) #= (Boisson &= jus_orange)) and
		((Pays &= japon) #= (Voiture &= datsun))
	),
	(foreach(m(Pays1, Couleur1, _, Voiture1, _, Numero1), Rue),
	param(Rue)
	do
		(foreach(m(_, Couleur2, _, _, Animal2, Numero2), Rue),
		param(Pays1), param(Couleur1), param(Voiture1), param(Numero1)
		do
			(((Couleur1 &= vert) and (Couleur2 &= blanc)) => (Numero2+1#=Numero1)) and
			(
				((Voiture1 &= ford) and (Animal2 &= renard)) or
				((Voiture1 &= toyota) and (Animal2 &= cheval)) or
				((Pays1 &= norvege) and (Couleur2 &= bleu)) 
			) => ((Numero1+1#=Numero2) or (Numero2+1#=Numero1))
		)
	),

	getVarList(Rue, Liste),
	labeling_symbolic(Liste),

	ecrit_maisons(Rue).

/**
 * Question 2.8
 */
resoudre.