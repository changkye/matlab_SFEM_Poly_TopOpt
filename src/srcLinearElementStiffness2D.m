function [Ksub,Kel,Xel,Vel] = srcLinearElementStiffness2D(Model,ivo,...
	wkInd,wkX,Q,W,nndof,Kel,Xel,Vel)
	% initialisation
	Ksub = sparse(2*nndof,2*nndof);
	Ksc = sparse(2*nndof,2*nndof);

	% Gauss point loop
	for ig = 1:size(W)
		% Polytopes shape funcs
		[N,dNdxi] = getShapeFunc2D_Poly(nndof,Q(ig,:));

		J = zeros(2,2); J = wkX'*dNdxi;
		invJ = zeros(2,2); invJ = inv(J);
		detJ = 0.0; detJ = det(J);

		dNdx = dNdxi*invJ;

		% strain-displacement matrix
		Bmat = zeros(3,2*nndof);
		Bmat(1,1:2:end) = dNdx(:,1);
		Bmat(2,2:2:end) = dNdx(:,2);
		Bmat(3,1:2:end) = dNdx(:,2);
		Bmat(3,2:2:end) = dNdx(:,1);

		% stiffness matrix
		BTC = zeros(2*nndof,3); BTC = Bmat'*Model.Cmat;
		BTCB = zeros(2*nndof,2*nndof); BTCB = BTC*Bmat;

		Ksc = Ksc + BTCB*W(ig)*detJ;
		Ksub = Ksub + Model.X(ivo)^Model.penal*BTCB*W(ig)*detJ;
	end
	Kel{ivo} = Ksc;
	Xel{ivo} = wkX;
	Vel(ivo,1) = polyarea(wkX(:,1),wkX(:,2));
end