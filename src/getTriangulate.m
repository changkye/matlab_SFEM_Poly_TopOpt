
function [p,Tri] = getTriangulate(nndof,xi)
	p = [cos(2*pi*((1:nndof))/nndof); sin(2*pi*((1:nndof))/nndof)]';
	p = [p; xi];
	Tri = zeros(nndof,3); 
	Tri(1:nndof,1) = nndof + 1;
	Tri(1:nndof,2) = 1:nndof; 
	Tri(1:nndof,3) = 2:nndof + 1;
	Tri(nndof,3) = 1;
end