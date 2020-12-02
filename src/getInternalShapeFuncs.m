function [Ni,Wmat,detJ0] = getInternalShapeFuncs(Model,wkX,gcoord,node_sc,Qi,Wi,nndof)
	% initialisation
	Ni = zeros(1,nndof); 
	Wmat = zeros(size(Wi,1),size(Wi,1));
	detJ0 = zeros(size(Wi,1),1); 
	mR = zeros(size(Wi,1),2);

	% current subcell coordinates
	subX = gcoord(node_sc,:);

	% Gauss point loop
	for ig = 1:size(Wi)
		% get global location of internal Gauss points
		[N0,dN0dxi] = getShapeFunc2D_T3(Qi(ig,:));
		J0 = zeros(2,2); J0 = dN0dxi'*subX;
		detJ0(ig) = det(J0);
		mR(ig,:) = N0'*subX;

		% shape funcs of current element at internal Gauss points
		N = getShapeFunc2D_Wachspress(wkX,mR(ig,:));
		Ni = Ni + (N*Wi(ig)*detJ0(ig))';

		% compute W mat
		Wmat(:,ig) = Wi(ig)*detJ0(ig)*[1; mR(ig,1); mR(ig,2)];
	end
end