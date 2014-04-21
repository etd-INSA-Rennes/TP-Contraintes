:- lib(ic).

/**
 * Question 4.1
 * getData(?TailleEquipes, ?NbEquipes, ?CapaBateaux, ?NbBateaux, ?NbConf)
 */
getData(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, 7):-
	%TailleEquipes = [](5, 5, 2, 1),
	TailleEquipes = [](7, 6, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
	dim(TailleEquipes, [NbEquipes]),
	%CapaBateaux = [](7, 6, 5),
	CapaBateaux = [](10, 10, 9, 8, 8, 8, 8, 8, 8, 7, 6, 4, 4),
	dim(CapaBateaux, [NbBateaux]).

/**
 * Question 4.2
 * defineVars(?T, +NbEquipes, +NbConf, +NbBateaux) 
 */
defineVars(T, NbEquipes, NbConf, NbBateaux):-
	dim(T, [NbEquipes, NbConf]),
	T #:: 1..NbBateaux.

/**
 * Question 4.3
 * getVarList(+T, ?L)
 */
getVarList(T, L):-
	dim(T, [NbEquipes, NbConf]),
	(for(J, 0, NbConf-1), fromto([], In, Out, L), param(T, NbEquipes, NbConf) do
		(for(I, 1, NbEquipes), foreach(Elem, SubL), param(T, J, NbConf) do
			JInv is NbConf - J,
			Elem is T[I, JInv]
		),
		append(SubL, In, Out)
	).

/**
 * Question 4.4
 * solve(?T)
 */
solve(T):-
	getData(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),
	defineVars(T, NbEquipes, NbConf, NbBateaux),

	pasMemeBateaux(T, NbEquipes, NbConf),
	pasMemePartenaires(T, NbEquipes, NbConf),
	capaBateaux(T, TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),

	getVarList(T, L),
	labeling(L).

/**
 * Question 4.5
 * pasMemeBateaux(+T, +NbEquipes, +NbConf)
 * Verifie qu'une equipe ne concours pas deux fois avec le meme bateau.
 * Il faut donc qu'il n'y ait pas deux fois la meme valeur sur une ligne.
 */
pasMemeBateaux(T, NbEquipes, NbConf):-
	(for(K, 1, NbEquipes), param(T, NbConf) do
		(for(I, 1, NbConf), param(T, NbConf, K) do
			(for(J, I+1, NbConf), param(T, I, K) do
				T[K, I] #\= T[K, J]
			)
		)
	).

/**
 * Question 4.6
 * Verifie qu'une equipe ne se retrouve pas partenaires deux fois avec la meme equipe.
 * pasMemePartenaires(+T, +NbEquipes, +NbConf)
 * T[i][k] == T[j][k] => T[i][x] != T[j][x] pour tout x \ x != k.
 */
pasMemePartenaires(T, NbEquipes, NbConf):-
	(for(I, 1, NbEquipes), param(T, NbEquipes, NbConf) do
		(for(J, I+1, NbEquipes), param(T, NbConf, I) do
			(for(K, 1, NbConf), param(T, NbConf, I, J) do
				(for(X, K+1, NbConf), param(T, I, J, K) do
					(T[I, K] #= T[J, K]) => (T[I, X] #\= T[J, X])
				)
			)
		)
	).

/**
 * Question 4.7
 * capaBateaux(+T, +TailleEquipes, +NbEquipes, +CapaBateaux, +NbBateaux, +NbConf)
 * Verifie que les capacites des bateaux sont respectees.
 */
capaBateaux(T, TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf):-
	(for(Conf, 1, NbConf), param(T, CapaBateaux, TailleEquipes, NbBateaux, NbEquipes) do
		(for(Bateau, 1, NbBateaux), param(T, CapaBateaux, TailleEquipes, Conf, NbEquipes) do
			(for(Equipe, 1, NbEquipes), fromto(0, TailleTotale, NewTailleTotale, TailleFinale),
			param(T, TailleEquipes, Bateau, Conf) do
				NewTailleTotale #= TailleTotale + (T[Equipe, Conf] #= Bateau) * TailleEquipes[Equipe]
			),
			CapaBateaux[Bateau] #>= TailleFinale
		)
	).

/**
 * Question 4.8
 * getVarListAlt(+T, ?List)
 * Alterne une petite et une grande equipe par rapport a getVarList.
 * Utilise le fait que les equipes sont donnes dans un tableau ordonne.
 * L'ajout a la liste est donc realise en partant des deux extremites et en allant vers le milieu.
 */
getVarListAlt(T, List):-
	dim(T, [NbEquipes, NbConf]),
	(for(J, 0, NbConf-1), fromto([], In, Out, List), param(T, NbEquipes, NbConf) do
		MoitieNbEquipes is div(NbEquipes, 2),
		(for(I, 0, MoitieNbEquipes-1), fromto([], SubIn, SubOut, SubList), param(MoitieNbEquipes, T, J, NbConf, NbEquipes) do
			% Les indices sont inverses car fromto inverse les listes:
			JInv is NbConf - J,
			IInv is MoitieNbEquipes - I,
			Elem1 is T[IInv, JInv], % Une grande equipe.
			Elem2 is T[NbEquipes-IInv+1, JInv], % Une petite equipe.
			SubOut = [Elem1, Elem2|SubIn]
		),
		append(SubList, In, Out)
	).


/**
 * Tests
 */
getVarList([]([](3, 8), [](4, 9), [](1, 5), [](7, 10)), L).
	L = [3, 4, 1, 7, 8, 9, 5, 10]

getVarListAlt([]([](3, 8), [](4, 9), [](1, 5), [](7, 10)), L).
	L = [3, 7, 4, 1, 8, 10, 9, 5]

solve(T).
	T = []([](1, 2, 3), [](2, 3, 1), [](3, 1, 2), [](3, 2, 1))
	Yes (0.00s cpu, solution 1, maybe more)
	T = []([](1, 3, 2), [](2, 1, 3), [](3, 2, 1), [](3, 1, 2))
	Yes (0.00s cpu, solution 2, maybe more)
	T = []([](1, 2, 3), [](3, 1, 2), [](2, 3, 1), [](1, 3, 2))
solve(T).
	T = []([](1, 2, 3, 4, 5, 6, 7), [](2, 1, 4, 3, 6, 5, 8), 
		[](3, 4, 1, 2, 7, 8, 5), [](4, 3, 1, 5, 2, 7, 6), 
		[](5, 6, 2, 1, 3, 4, 9), [](2, 3, 5, 1, 4, 9, 10), 
		[](3, 1, 2, 6, 4, 10, 11), [](6, 5, 7, 2, 1, 3, 4), 
		[](6, 7, 5, 8, 2, 1, 3), [](7, 5, 6, 8, 3, 2, 1), 
		[](7, 8, 9, 6, 1, 11, 2), [](8, 7, 6, 9, 10, 12, 2), 
		[](8, 9, 7, 10, 11, 1, 12), [](1, 4, 8, 3, 9, 7, 10), 
		[](4, 2, 8, 10, 7, 3, 9), [](5, 8, 3, 11, 6, 9, 1), 
		[](9, 6, 4, 5, 8, 11, 13), [](9, 8, 10, 12, 13, 2, 11), 
		[](9, 10, 8, 11, 12, 13, 2), [](9, 11, 12, 13, 1, 10, 3), 
		[](10, 9, 11, 7, 12, 3, 13), [](10, 11, 9, 12, 8, 1, 4),
		[](10, 12, 13, 11, 9, 2, 3), [](11, 9, 10, 13, 8, 4, 5), 
		[](11, 10, 12, 9, 13, 5, 1), [](11, 12, 9, 7, 10, 13, 8), 
		[](12, 10, 13, 7, 11, 9, 4), [](12, 13, 11, 9, 8, 2, 6), 
		[](13, 11, 10, 7, 9, 8, 1))
	Yes (204.77s cpu, solution 1, maybe more)