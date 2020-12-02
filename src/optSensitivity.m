function Model = optSensitivity(Model)
	% mesh independent filter
	Model = getFilter(Model);

	% optimality criteria
	Model = optimalityCriteria(Model);
end
% 
function Model = getFilter(Model)
	% initialise
	dcn = zeros(Model.numElems,1);
	xy = zeros(Model.numElems,2);
	
	% compute centroids of elements
	for i = 1:Model.numElems
		xy(i,:) = mean(Model.Xel{i});
    end
    
%     rmin = sum(Model.Vel)/Model.numElems;
	
    for i = 1:Model.numElems
		sumHf = 0.0;
		for j = 1:Model.numElems
			Hf = Model.rmin - sqrt((xy(i,1)-xy(j,1))^2 + (xy(i,2)-xy(j,2))^2);
%             Hf = rmin - sqrt((xy(i,1)-xy(j,1))^2 + (xy(i,2)-xy(j,2))^2);
			sumHf = sumHf + max(0,Hf);
			dcn(i) = dcn(i) + max(0,Hf)*Model.X(j)*Model.dc(j);
		end
		dcn(i) = dcn(i)/(Model.X(i)*sumHf);
	end
	Model.dc = dcn;
end
% 
function Model = optimalityCriteria(Model)
	% initialise
	E = Model.ocParam(1); Z = Model.ocParam(2);
	
	Vol = sum(Model.Vel);
	l1 = 0; l2 = 1e6; EPS = 1e-6;
	while (l2-l1) > EPS
		lmid = mean([l1 l2]);

		xnew = max(0.001,max((1-Z)*Model.X,...
            min(1.0,min((1+Z)*Model.X,...
            Model.X.*((max(0,-Model.dc)./(lmid*Model.Vel)).^E)))));

		if (sum(xnew.*Model.Vel) - Model.volfr*Vol) > 0
			l1 = lmid;
		else
			l2 = lmid;
		end
	end
	Model.X = xnew;
end