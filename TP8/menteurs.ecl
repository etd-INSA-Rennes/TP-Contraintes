:- lib(ic).
:- lib(ic_symbolic).

:- local domain(humain(homme, femme)).

/**
 * Question 8.1
 * affirme(?S, ?A)
 */
affirme(S, A):-
	S &= femme => A #= 1.

/**
 * Question 8.2
 * affirme(?S, ?A1, ?A2)
 */
affirme(S, A1, A2):-
	S &= homme => ((A1#=1 and A2#=0) or (A1#=0 and A2#=1)).

/**
 * Question 8.3
 */
domain(Parent1, Parent2, Enfant, AffE, AffEselonP1, AffP1, Aff1P2, Aff2P2):-
	Parent1 &:: humain,
	Parent2 &:: humain,
	Enfant &:: humain,
	AffE #:: 0..1,
	AffEselonP1 #:: 0..1,
	AffP1 #:: 0..1,
	Aff1P2 #:: 0..1,
	Aff2P2 #:: 0..1.

/**
 * Question 8.4
 */
/**
 * labeling_symbolic(+Liste)
 */
labeling_symbolic([]).
labeling_symbolic([Var|Liste]):-
	ic_symbolic:indomain(Var),
	labeling_symbolic(Liste).

resoudre(Parent1, Parent2, Enfant, AffE, AffEselonP1, AffP1, Aff1P2, Aff2P2):-
	domain(Parent1, Parent2, Enfant, AffE, AffEselonP1, AffP1, Aff1P2, Aff2P2),
	
	AffEselonP1 #= (Enfant &= femme),
	AffP1 #= (AffEselonP1 #= AffE),
	Aff1P2 #= (Enfant &= homme),
	Aff2P2 #= (AffE #= 0),

	affirme(Parent1, AffP1),
	affirme(Parent2, Aff1P2, Aff2P2),
	affirme(Parent2, Aff1P2),
	affirme(Parent2, Aff2P2),

	Parent1 &\= Parent2,

	labeling_symbolic([Parent1, Parent2, Enfant, AffE, AffEselonP1, AffP1, Aff1P2, Aff2P2]).