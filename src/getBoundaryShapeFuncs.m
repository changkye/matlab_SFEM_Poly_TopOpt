function [fx,fy] = getBoundaryShapeFuncs(Model,wkX,gcoord,node_sc,Qb,Wb,nndof)
	% initialisation
	fx = zeros(3,nndof); fy = zeros(3,nndof);

	% current subcell coordinates
	subX = gcoord(node_sc,:);
	nxy = getNormals(subX);
	conn = [1 2; 2 3; 3 1];

	% subcell loop
	for is = 1:size(nxy,1)
		X = subX(conn(is,:),:);
		bxy = zeros(3,nndof);
		for ig = 1:size(Wb)
			% location of Gauss points on boundaries
			[Ng,dNdxi] = getShapeFunc1D_L2(Qb(ig,:));
			xieta_gp = Ng'*X;

			% map 1D points to the element
			J = zeros(1,2); J = dNdxi'*X;
			detJ = 0.0; detJ = norm(J); if detJ <=0 keyboard; end

			% compute element shape funcs
			N = zeros(nndof,1);
			if ismember(size(gcoord,1),node_sc(conn(is,:)))
				N = getShapeFunc2D_Wachspress(wkX,xieta_gp);
			else
				N(node_sc(conn(is,:)),1) = Ng;
			end
			% 
			bxy = bxy + N'.*[1; xieta_gp(1); xieta_gp(2)]*detJ*Wb(ig);
		end
		% 
		fx = fx + nxy(is,1)*bxy;
		fy = fy + nxy(is,2)*bxy;
	end
end