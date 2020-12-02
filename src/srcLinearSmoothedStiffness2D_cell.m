function [Ksub,Kel,Xel,IDel,Vel] = srcLinearSmoothedStiffness2D_cell(Model,...
    ivo,wkInd,wkX,Qi,Wi,Qb,Wb,nndof,Kel,Xel,IDel,Vel)
	% initialisation
	Ksub = sparse(2*nndof,2*nndof);
	Ksc = sparse(2*nndof,2*nndof);

	% current subcell coordinates & connectivities
	gcoord = zeros(nndof+1,2); gcoord = [wkX; mean(wkX)];
	node_sc = zeros(nndof,3);
	node_sc = delaunay(gcoord(:,1),gcoord(:,2));
    if strcmp(Model.pflag.pMesh,'yes')
        trimesh(node_sc,gcoord(:,1),gcoord(:,2));
    end
    node_sc = tricheck(gcoord,node_sc);
	IDel{ivo} = node_sc;

	% subcell loop
	for is = 1:size(node_sc,1)
		% compute shape functions at internal Gauss points
		[Ni,Wmat,detJ] = getInternalShapeFuncs(Model,wkX,gcoord,node_sc(is,:),Qi,Wi,nndof);

		% compute shape functions at boundary Gauss points
		[fx,fy] = getBoundaryShapeFuncs(Model,wkX,gcoord,node_sc(is,:),Qb,Wb,nndof);
		fx(2,:) = fx(2,:) - Ni;
		fy(3,:) = fy(3,:) - Ni;

		% compute derivatives basis functions
		dx = zeros(3,nndof); dy = zeros(3,nndof);
		dx = Wmat\fx; dy = Wmat\fy;

		% compute stiffness matrix
		for ig = 1:size(Wi)
			% smoothed strain-displacement matrix
			Bmat = zeros(3,2*nndof);
			Bmat(1,1:2:end) = dx(ig,:);
			Bmat(2,2:2:end) = dy(ig,:);
			Bmat(3,1:2:end) = dy(ig,:);
			Bmat(3,2:2:end) = dx(ig,:);

			% stiffness matrix
			BTC = zeros(2*nndof,3); BTC = Bmat'*Model.Cmat;
			BTCB = zeros(2*nndof,2*nndof); BTCB = BTC*Bmat;

			Ksc = Ksc + BTCB*Wi(ig)*detJ(ig);
			Ksub = Ksub + Model.X(ivo)^Model.penal*BTCB*Wi(ig)*detJ(ig);
		end
	end
	Kel{ivo} = Ksc;
	Xel{ivo} = wkX;
	Vel(ivo,1) = polyarea(wkX(:,1),wkX(:,2));
end