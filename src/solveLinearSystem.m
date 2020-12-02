function Model = solveLinearSystem(Model);
	% initialisation
	U = zeros(Model.DOFs,1);
	K1 = Model.K; F1 = Model.F;

	% applying BCs
	for i = 1:length(Model.BCDof)
		c = Model.BCDof(i);
		for j = 1:Model.DOFs
			K1(c,j) = 0.0;
		end
		K1(c,c) = 1.0;
		F1(c,1) = Model.BCVal(i);
	end

	% get nodal displacement
	U = K1\F1;
	Model.U = U;
end