:- lib(ic).
:- lib(branch_and_bound).

/**
 * Question 5.1
 */
/**
 * techniciens(?Techniciens)
 */
techniciens(Techniciens):-
	Techniciens = [](5, 7, 2, 6, 9, 3, 7, 5, 3).

/**
 * quantites(?Quantites)
 */
quantites(Quantites):-
	Quantites = [](140, 130, 60, 95, 70, 85, 100, 30, 45).

/**
 * benefices(?Benefices)
 */
benefices(Benefices):-
	Benefices = [](4, 5, 8, 5, 6, 4, 7, 10, 11).

/**
 * fabrique(?Fabrique)
 */
fabrique(Fabriquer):-
	techniciens(Techniciens),
	dim(Techniciens, [Taille]),
	dim(Fabriquer, [Taille]),
	Fabriquer #:: 0..1.


/**
 * Question 5.2
 */
/**
 * nb_ouvriers(?Fabriquer, ?NbOuvriers)
 * Recupere le nombre d'ouvriers necessaire.
 */
nb_ouvriers(Fabriquer, NbOuvriers):-
	techniciens(Techniciens),
	dim(Techniciens, [Taille]),
	(for(I, 1, Taille), fromto(0, In, Out, NbOuvriers), param(Fabriquer, Techniciens) do
		Out #= Fabriquer[I] * Techniciens[I] + In
	).

/**
 * benefices_totaux(?Fabriquer, ?BeneficesTotaux)
 * Calcule les benefices totaux pour chaque telephone.
 */
benefices_totaux(Fabriquer, BeneficesTotaux):-
	quantites(Quantites),
	benefices(Benefices),
	dim(Benefices, [Taille]),
	dim(BeneficesTotaux, [Taille]),
	(for(I, 1, Taille), param(BeneficesTotaux, Fabriquer, Quantites, Benefices) do
		BeneficesTotaux[I] #= Fabriquer[I] * Quantites[I] * Benefices[I]
	).

/**
 * profit_total(?Fabriquer, ?Profit)
 * Calcule le profit total.
 */
profit_total(Fabriquer, Profit):-
	benefices_totaux(Fabriquer, BeneficesTotaux),
	(foreachelem(Benef, BeneficesTotaux), fromto(0, In, Out, Profit) do
		Out #= Benef + In
	).


/**
 * Question 5.3
 */
/**
 * pose_contraintes(?Fabriquer, ?NbTechniciensTotal, ?Profit)
 */
pose_contraintes(Fabriquer, NbTechniciensTotal, NbOuvriers, Profit):-
	% Le nombre d'ouvriers est positif et inferieur au nombre maximal de techniciens.
	nb_ouvriers(Fabriquer, NbOuvriers),
	NbOuvriers #=< NbTechniciensTotal,
	NbOuvriers #>= 0,
	profit_total(Fabriquer, Profit).

/**
 * resoudre(?Fabriquer, ?NbTechniciensTotal, ?NbOuvriers, ?Profit)
 */
resoudre(Fabriquer, NbTechniciensTotal, NbOuvriers, Profit):-
	fabrique(Fabriquer),
	pose_contraintes(Fabriquer, NbTechniciensTotal, NbOuvriers, Profit),
	labeling(Fabriquer).


/**
 * Question 5.4
 */
equation(X):-
	[X, Y, Z, W] #:: [0..10],
	X #= Z + Y + 2*W,
	X #\= Z + Y + W,
	labeling([X, Y, Z, W]).

% Labeling on X:
minimize(equation(X), X).
	Found a solution with cost 1
	Found no solution with cost -1.0Inf .. 0
	X = 1
	Yes (0.00s cpu)
% Labeling on X, Y, Z, W:
minimize(equation(X), X).
	Found a solution with cost 2
	Found no solution with cost -1.0Inf .. 1
	X = 2
	Yes (0.00s cpu)


/**
 * Question 5.5
 */
resoudre_inv(Fabriquer, NbTechniciensTotal, NbOuvriers, ProfitInv):-
	resoudre(Fabriquer, NbTechniciensTotal, NbOuvriers, Profit),
	ProfitInv #= -Profit.
resoudre_opti(Fabriquer, NbTechniciensTotal, NbOuvriers, Profit):-
	minimize(resoudre_inv(Fabriquer, NbTechniciensTotal, NbOuvriers, ProfitInv), ProfitInv),
	Profit is -ProfitInv.


/**
 * Question 5.6
 */
resoudre_licenciements(Fabriquer, NbTechniciensTotal, NbOuvriers, Profit):-
	Profit #> 1000,
	minimize(resoudre(Fabriquer, NbTechniciensTotal, NbOuvriers, Profit), NbOuvriers).



/**
 * Tests
 */
fabrique(Fabriquer).
	Fabriquer = [](_11162{[0, 1]}, _11180{[0, 1]}, _11198{[0, 1]}, _11216{[0, 1]}, _11234{[0, 1]}, _11252{[0, 1]}, _11270{[0, 1]}, _11288{[0, 1]}, _11306{[0, 1]})
	Yes (0.00s cpu)

fabrique(Fabriquer), nb_ouvriers(Fabriquer, NbOuvriers).
	Fabriquer = [](_376{[0, 1]}, _394{[0, 1]}, _412{[0, 1]}, _430{[0, 1]}, _448{[0, 1]}, _466{[0, 1]}, _484{[0, 1]}, _502{[0, 1]}, _520{[0, 1]})
	NbOuvriers = NbOuvriers{0 .. 47}
	There are 9 delayed goals. Do you want to see them? (y/n)
	Yes (0.00s cpu)

fabrique(Fabriquer), benefices_totaux(Fabriquer, Benefs).
	Fabriquer = [](_376{[0, 1]}, _394{[0, 1]}, _412{[0, 1]}, _430{[0, 1]}, _448{[0, 1]}, _466{[0, 1]}, _484{[0, 1]}, _502{[0, 1]}, _520{[0, 1]})
	Benefs = [](_685{0 .. 560}, _1249{0 .. 650}, _1813{0 .. 480}, _2377{0 .. 475}, _2941{0 .. 420}, _3505{0 .. 340}, _4069{0 .. 700}, _4633{0 .. 300}, _5197{0 .. 495})
	There are 9 delayed goals. Do you want to see them? (y/n)
	Yes (0.01s cpu)

fabrique(Fabriquer), profit_total(Fabriquer, Profit).
	Fabriquer = [](_376{[0, 1]}, _394{[0, 1]}, _412{[0, 1]}, _430{[0, 1]}, _448{[0, 1]}, _466{[0, 1]}, _484{[0, 1]}, _502{[0, 1]}, _520{[0, 1]})
	Profit = Profit{0 .. 4420}
	There are 17 delayed goals. Do you want to see them? (y/n)
	Yes (0.00s cpu)

fabrique(Fabriquer), pose_contraintes(Fabriquer, 22, Profit).
	Fabriquer = [](_390{[0, 1]}, _408{[0, 1]}, _426{[0, 1]}, _444{[0, 1]}, _462{[0, 1]}, _480{[0, 1]}, _498{[0, 1]}, _516{[0, 1]}, _534{[0, 1]})
	Profit = Profit{0 .. 4420}
	There are 26 delayed goals. Do you want to see them? (y/n)
	Yes (0.00s cpu)

resoudre(Fabriquer, 22, NbOuvriers, Profit).
	Fabriquer = [](0, 0, 0, 0, 0, 0, 0, 0, 0)
	NbOuvriers = 0
	Profit = 0
	Yes (0.00s cpu, solution 1, maybe more)
	Fabriquer = [](0, 0, 0, 0, 0, 0, 0, 0, 1)
	NbOuvriers = 3
	Profit = 495
	Yes (0.00s cpu, solution 2, maybe more)
	Fabriquer = [](0, 0, 0, 0, 0, 0, 0, 1, 0)
	NbOuvriers = 5
	Profit = 300
	Yes (0.00s cpu, solution 3, maybe more)
	...

Profit #> 2500, resoudre(Fabriquer, 22, NbOuvriers, Profit).
	Profit = 2665
	Fabriquer = [](0, 1, 1, 0, 0, 1, 1, 0, 1)
	NbOuvriers = 22
	Yes (0.00s cpu, solution 1, maybe more)
	...
Profit #> 2665, resoudre(Fabriquer, 22, NbOuvriers, Profit).
	No (0.01s cpu)

resoudre_opti(Fabriquer, 22, NbOuvriers, Profit).
	Found a solution with cost 0
	Found a solution with cost -495
	Found a solution with cost -795
	Found a solution with cost -1195
	Found a solution with cost -1495
	Found a solution with cost -1535
	Found a solution with cost -1835
	Found a solution with cost -1955
	Found a solution with cost -1970
	Found a solution with cost -2010
	Found a solution with cost -2015
	Found a solution with cost -2315
	Found a solution with cost -2490
	Found a solution with cost -2665
	Found no solution with cost -1.0Inf .. -2666
	Fabriquer = [](0, 1, 1, 0, 0, 1, 1, 0, 1)
	NbOuvriers = 22
	Profit = 2665
	Yes (0.01s cpu)

resoudre_licenciements(Fabriquer, 22, NbOuvriers, Profit).
	Found a solution with cost 10
	Found a solution with cost 9
	Found a solution with cost 8
	Found a solution with cost 7
	Found no solution with cost -1.0Inf .. 6
	Fabriquer = [](1, 0, 1, 0, 0, 0, 0, 0, 0)
	NbOuvriers = 7
	Profit = 1040
	Yes (0.00s cpu)