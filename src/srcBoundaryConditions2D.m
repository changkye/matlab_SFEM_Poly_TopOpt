function Model = srcBoundaryConditions2D(Model)
	% 
	Bound = str2func(['getBC_' Model.bcType]);
	Model = Bound(Model);
end
% 
function Model = getBC_Cantilever(Model)
	% get Dirichlet BCs
	BCNodes = find(Model.Nodes(:,1)==min(Model.Nodes(:,1)));
	BCDof = zeros(1,2*length(BCNodes));
	BCDof(1:2:end) = 2*BCNodes-1; BCDof(2:2:end) = 2*BCNodes;
	BCVal = zeros(1,length(BCDof));

	% get Neumann BCs
	F = zeros(Model.DOFs,1);
	edof = find(Model.Nodes(:,1)==max(Model.Nodes(:,1)) &...
		Model.Nodes(:,2)==min(Model.Nodes(:,2)));
	F(2*edof,1) = -Model.P;

	% 
	Model.BCDof = BCDof;
	Model.BCVal = BCVal;
	Model.F = F;
end
% 
function Model = getBC_MBBbeam(Model)
	% get Dirichlet BCs
	BCNodes = Model.BCNodes(:,1)';
	BCDof = zeros(1,length(BCNodes));
	BCDof(1:end-1) = 2*BCNodes(1:end-1)-1; BCDof(end) = 2*BCNodes(end);
	BCVal = zeros(1,length(BCDof));

	% get Neumann BCs
	F = zeros(Model.DOFs,1);
	edof = Model.LoadNodes(1);
	F(2*edof,1) = -Model.P;

	% 
	Model.BCDof = BCDof;
	Model.BCVal = BCVal;
	Model.F = F;
end
% 
function Model = getBC_Michell(Model)
	% get Dirichlet BCs
	BCNodes = Model.BCNodes(:,1)';
	BCDof = zeros(1,2*length(BCNodes));
	BCDof(1:2:end) = 2*BCNodes-1; BCDof(2:2:end) = 2*BCNodes;
	BCVal = zeros(1,2*length(BCDof));

	% get Neumann BCs
	F = zeros(Model.DOFs,1);
	edof = Model.LoadNodes(1);
	F(2*edof,1) = -Model.P;

	% 
	Model.BCDof = BCDof;
	Model.BCVal = BCVal;
	Model.F = F;
end
% 
function Model = getBC_Serpentine(Model)
	% get Dirichlet BCs
	BCNodes = Model.BCNodes(:,1)';
	BCDof = zeros(1,2*length(BCNodes));
	BCDof(1:2:end) = 2*BCNodes-1; BCDof(2:2:end) = 2*BCNodes;
	BCVal = zeros(1,2*length(BCDof));

	% get Neumann BCs
	F = zeros(Model.DOFs,1);
	edof = Model.LoadNodes(1);
	F(2*edof,1) = -Model.P;

	% 
	Model.BCDof = BCDof;
	Model.BCVal = BCVal;
	Model.F = F;
end