function Model = srcLinearConstitutive2D(Model)
	% initialisation
	Cmat = zeros(3,3);
	E = Model.matParams(1); nu = Model.matParams(2);

	if strcmp(Model.stressType,'plane_str')
		% plane stress
    	Cmat = E/(1-nu^2)*[1 nu 0; nu 1 0; 0 0 (1-nu)/2];
	else
		% plane strain
    	Cmat = E/(1+nu)/(1-2*nu)*[1-nu nu 0; nu 1-nu 0; 0 0 (1/2)-nu];
	end
	Model.Cmat = Cmat;
end
