function [N,dNdxi] = getShapeFunc2D_T3(pt)
	% shape funcs & derivs of three-node triangular element

	% initialisation
	N = zeros(3,1); dNdxi = zeros(3,2);
	
	% shape funcs
	N = [1 - pt(1) - pt(2); pt(1); pt(2)];

	% shape funcs derivs
	dNdxi = [-1 -1; 1 0; 0 1];
end