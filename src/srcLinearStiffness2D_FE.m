function Model = srcLinearStiffness2D_FE(Model)
	% initialisation
	K = sparse(Model.DOFs,Model.DOFs);
	Kel = cell(Model.numElems,1);
	Xel = cell(Model.numElems,1);
	Vel = zeros(Model.numElems,1);

	% element loop
	for ivo = 1:Model.numElems
		% current element connectivities
		wkInd = Model.Elements{ivo}; nndof = length(wkInd);
		
		% current element coordinates
		wkX = zeros(nndof,2); wkX = Model.Nodes(wkInd,:);

		% current Gauss quadrature
		[Q,W] = srcGaussQuadrature_FE(nndof);

		% current element area
		Vel(ivo,1) = polyarea(wkX(:,1),wkX(:,2));
		
		% subcell loop
		[Ksub,Kel,Xel,Vel] = srcLinearElementStiffness2D(Model,ivo,wkInd,wkX,Q,W,nndof,Kel,Xel,Vel);

		% assemble global stiffness matrix
		edof = zeros(1,2*nndof);
		edof(1:2:end) = 2*wkInd - 1;
		edof(2:2:end) = 2*wkInd;
		K(edof,edof) = K(edof,edof) + Ksub;
	end
	Model.K = K;
	Model.Kel = Kel;
	Model.Xel = Xel;
	Model.Vel = Vel;
end