function Model = srcLinearStiffness2D_cell(Model)
	% initialisation
	K = sparse(Model.DOFs,Model.DOFs);
	Kel = cell(Model.numElems,1);
	Xel = cell(Model.numElems,1);
	IDel = cell(Model.numElems,1);
	Vel = zeros(Model.numElems,1);

	% get Gauss points
	[Qi,Wi,Qb,Wb] = srcGaussQuadrature;

	% element loop
	for ivo = 1:Model.numElems
		% current element connectivities
		wkInd = Model.Elements{ivo}; nndof = length(wkInd);
		
		% current element coordinates
		wkX = zeros(nndof,2); wkX = Model.Nodes(wkInd,:);
		% current element area
		Vel(ivo,1) = polyarea(wkX(:,1),wkX(:,2));
		
		% subcell loop
		[Ksub,Kel,Xel,IDel,Vel] = srcLinearSmoothedStiffness2D_cell(Model,ivo,wkInd,wkX,Qi,Wi,Qb,Wb,nndof,Kel,Xel,IDel,Vel);

		% assemble global stiffness matrix
		edof = zeros(1,2*nndof);
		edof(1:2:end) = 2*wkInd - 1;
		edof(2:2:end) = 2*wkInd;
		K(edof,edof) = K(edof,edof) + Ksub;
	end
	Model.K = K;
	Model.Kel = Kel;
	Model.Xel = Xel;
    Model.IDel = IDel;
	Model.Vel = Vel;
end