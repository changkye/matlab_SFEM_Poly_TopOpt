function [N,dNdxi] = getShapeFunc1D_L2(pt)
	% 1D 2-node line element
	% initialisation
	N = zeros(2,1); dNdxi = zeros(2,1);

	% shape funcs
	N = [1-pt; 1+pt]/2;

	% shape funcs derivs
	dNdxi = [-1; 1]/2;
end