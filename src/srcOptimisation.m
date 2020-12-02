function Model = srcOptimisation(Model)
	% initialisation
	loop = 0.0; change = 1.0; cnt = 0;

	% distribute volume fraction to each element
	Model.X = zeros(Model.numElems,1); Model.X(:) = Model.volfr;

	% iteration
	while change > 0.01
		loop = loop + 1; 
		oldX = zeros(Model.numElems,1); oldX = Model.X;
		Model.c = 0.0;

		% compute stiffness matrix
		Model = srcLinearStiffness2D_cell(Model);

		% solve system
		Model = solveLinearSystem(Model);

		% objective functions
		Model = optObjective(Model);

		% check sensitivity
		Model = optSensitivity(Model);

		% check design variable changes
		change = max(max(abs(Model.X-oldX)));
		fprintf(1,'Iter: %4d\tObj: %15.5f\tVol: %8.5f\tCh: %8.5f\n',loop,Model.c,...
        	sum(sum(Model.X.*Model.Vel))/(sum(sum(Model.Vel))),change);
                
		cnt = cnt + 1;
        Model.Obj(cnt) = Model.c;
	end
    disp('********************************************************************')
    disp('  Minimum compliance problem with Optimality Criteria Method')
    disp('  Filter method: Density based method')
end