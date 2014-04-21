:- lib(ic).

/**
 * Question 1.11
 * vabs(?Val, ?AbsVal)
 */
vabs(Val, AbsVal):-
	AbsVal #> 0,
	(
		Val #= AbsVal
	;
		Val #= -AbsVal
	),
	labeling([Val, AbsVal]).

/**
 * vabsIC(?Val, ?AbsVal)
 */
vabsIC(Val, AbsVal):-
	AbsVal #> 0,
	Val #= AbsVal or Val #= -AbsVal,
	labeling([Val, AbsVal]).

/**
 * Question 1.12
 */
X #:: -10..10, vabs(X, Y).
	X = 1
	Y = 1
	Yes (0.01s cpu, solution 1, maybe more)
	X = 2
	Y = 2
	Yes (0.01s cpu, solution 2, maybe more)
	X = 3
	Y = 3
	Yes (0.01s cpu, solution 3, maybe more)
	...
X #:: -10..10, vabsIC(X, Y).
	X = -10
	Y = 10
	Yes (0.00s cpu, solution 1, maybe more)
	X = -9
	Y = 9
	Yes (0.00s cpu, solution 2, maybe more)
	X = -8
	Y = 8
	Yes (0.00s cpu, solution 3, maybe more)
	...

/**
 * Question 1.13
 * faitListeV1(?ListVar, ?Taille, +Min, +Max)
 * faitListeV1(ListVar, 2, 1, 3)
 */
faitListeV1([], 0, _, _).
faitListeV1([First|Rest], Taille, Min, Max):-
	First #:: Min..Max,
	Taille #> 0,
	Taille1 #= Taille - 1,
	faitListeV1(Rest, Taille1, Min, Max).

/**
 * faitListe(?ListVar, ?Taille, +Min, +Max)
 */
faitListe(ListVar, Taille, Min, Max):-
	length(ListVar, Taille),
	ListVar #:: Min..Max.

/**
 * Question 1.14
 * suite(?ListVar)
 */
suite([Xi, Xi1, Xi2]):-
	checkRelation(Xi, Xi1, Xi2).
suite([Xi, Xi1, Xi2|Rest]):-
	checkRelation(Xi, Xi1, Xi2),
	suite([Xi1, Xi2|Rest]).

/**
 * checkRelation(?Xi, ?Xi1, ?Xi2)
 */
checkRelation(Xi, Xi1, Xi2):-
	vabs(Xi1, VabsXi1),
	Xi2 #= VabsXi1 - Xi.

/**
 * Question 1.15
 * checkPeriode(+ListVar).
 */
faitListe(ListVar, 11, -1000, 1000), suite(ListVar), ListVar = [X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11|Rest], X1 #\= X10 or X2 #\= X11, labeling(ListVar).
	No (133.20s cpu)


/**
 * Tests
 */
vabs(5, 5). => Yes
vabs(5, -5). => No
vabs(-5, 5). => Yes
vabs(X, 5).
vabs(X, AbsX). 
vabsIC(5, 5). => Yes
vabsIC(5, -5). => No
vabsIC(-5, 5). => Yes
vabsIC(X, 5).
vabsIC(X, AbsX).

faitListe(ListVar, 5, 1, 3).
	ListVar = [_236{1 .. 3}, _254{1 .. 3}, _272{1 .. 3}, _290{1 .. 3}, _308{1 .. 3}]
	Yes (0.00s cpu)
faitListe(ListVar, _, 1, 3).
	ListVar = []
	Yes (0.00s cpu, solution 1, maybe more)
	ListVar = [_217{1 .. 3}]
	Yes (0.00s cpu, solution 2, maybe more)
	ListVar = [_222{1 .. 3}, _240{1 .. 3}]
	Yes (0.00s cpu, solution 3, maybe more)
	...
faitListe([_, _, _, _, _], Taille, 1, 3).
	Taille = 5
	Yes (0.00s cpu)
faitListe(ListVar, 18, -9, 9), suite(ListVar).
	ListVar = [-2, 1, 3, 2, -1, -1, 2, 3, 1, -2, 1, 3, 2, -1, -1, 2, 3, 1]
	Yes (0.00s cpu, solution 1, maybe more)
	ListVar = [-3, 1, 4, 3, -1, -2, 3, 5, 2, -3, 1, 4, 3, -1, -2, 3, 5, 2]
	Yes (0.00s cpu, solution 2, maybe more)
	ListVar = [-4, 1, 5, 4, -1, -3, 4, 7, 3, -4, 1, 5, 4, -1, -3, 4, 7, 3]
	Yes (0.00s cpu, solution 3, maybe more)
	... (99 solutions)