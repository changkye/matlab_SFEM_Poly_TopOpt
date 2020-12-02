function Model = optObjective(Model)
	% initialisation
	dc = zeros(Model.numElems,1);
	
	for iel = 1:Model.numElems
		wkInd = Model.Elements{iel}; ndof = length(wkInd);
		edof = zeros(1,2*ndof); 
		edof(1:2:end) = 2*wkInd-1; edof(2:2:end) = 2*wkInd;

		Uel = zeros(2*ndof,1);
		Uel = Model.U(edof);

		Model.c = Model.c + Model.X(iel)^Model.penal*(Uel'*Model.Kel{iel}*Uel);
		dc(iel) = -Model.penal*Model.X(iel)^(Model.penal-1)*(Uel'*Model.Kel{iel}*Uel);
	end
	Model.dc = dc;
end