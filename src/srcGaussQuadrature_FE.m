function [Q,W] = srcGaussQuadrature_FE(nndof)
	% get triangular Gauss points & Weights
	quadPt = zeros(3,2); quadWt = ones(3,1);
	quadPt(:,1) = [0.1666666666667; 0.6666666666667; 0.1666666666667];
	quadPt(:,2) = [0.1666666666667; 0.1666666666667; 0.6666666666667];
	quadWt = 0.333333333333*quadWt/2;
	
	% triangulate from origin
	[p,Tri] = getTriangulate(nndof,[0,0]);

	Q = zeros(nndof*length(quadWt),2); W = zeros(nndof*length(quadWt),1);
	for i = 1:nndof
		wkInd = Tri(i,:);
		for j = 1:length(quadWt)
			[N,dNdxi] = getShapeFunc2D_T3(quadPt(j,:));
			J = p(wkInd,:)'*dNdxi;
			l = (i-1)*length(quadWt) + j;
			Q(l,:) = N'*p(wkInd,:);
			W(l) = det(J)*quadWt(j);
		end
	end
end

