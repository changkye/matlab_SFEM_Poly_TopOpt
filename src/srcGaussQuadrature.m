function [Qi,Wi,Qb,Wb] = srcGaussQuadrature
	% get internal Gauss points & Weights
	quadPt = zeros(3,2); quadWt = ones(3,1);
	quadPt(:,1) = [0.1666666666667; 0.6666666666667; 0.1666666666667];
	quadPt(:,2) = [0.1666666666667; 0.1666666666667; 0.6666666666667];
	quadWt = 0.333333333333*quadWt;
	% 
	Qi = zeros(3,2); Wi = zeros(3,1);
	Qi = quadPt; Wi = quadWt/2;
	
	% get boundary Gauss points & Weights
	quadPt = zeros(2,1); quadWt = ones(2,1);
	quadPt = 0.577350269189626*[1; -1];
	% 
	Qb = zeros(2,1); Wb = zeros(2,1);
	Qb = quadPt; Wb = quadWt;
end
