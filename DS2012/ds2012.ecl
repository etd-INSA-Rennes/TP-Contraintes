:- lib(ic).

/**
 * domain(?Numbers)
 */
domain(Numbers):-
	Numbers = [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _],
	Numbers #:: 1..19.

/**
 * solve(+Numbers)
 */
constraints1([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S]):-
	A + D + H #= 38, 
	B + E + I + M #= 38, 
	C + F + J + N + Q #= 38, 
	G + K + O + R #= 38, 
	L + P + S #= 38.

/**
 * solve(+Numbers)
 */
constraints2([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S]):-
	C + G + L #= 38, 
	B + F + K + P #= 38, 
	A + E + J + O + S #= 38, 
	D + I + N + R #= 38, 
	H + M + Q #= 38.

/**
 * symmetries(+Numbers)
 */
symmetries([A, _, C, _, _, _, _, H, _, _, _, L, _, _, _, _, Q, _, S]):-
	A #< C,
	A #< H,
	A #< L,
	A #< Q,
	A #< S,
	H #< C.

/**
 * solve(?Numbers)
 */
solve(Numbers):-
	domain(Numbers),
	alldifferent(Numbers),
	constraints1(Numbers),
	constraints2(Numbers),
	symmetries(Numbers),
	Numbers = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S],
	Vars = [J, A, C, H, L, Q, S, D, G, M, P, F, K, E, I, N, O, B, R],
	labeling(Vars).