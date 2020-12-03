function [N,dNdxi] = getShapeFunc2D_Poly(nn,pt)
	% initialisation
	N = zeros(nn,1); dNdxi = zeros(nn,2);
	alfa = zeros(nn,1); dalfa = zeros(nn,2);
	sum_alfa = 0.0; sum_dalfa = zeros(1,2); 
	A = zeros(nn,1); dA = zeros(nn,2);

	[p,Tri] = getTriangulate(nn,pt);
	for i = 1:nn
  		wkInd = Tri(i,:); pT = p(wkInd,:);
  		A(i) = 1/2*det([pT,ones(3,1)]);
  		dA(i,1) = 1/2*(pT(3,2)-pT(2,2));
  		dA(i,2) = 1/2*(pT(2,1)-pT(3,1));
	end
	A = [A(nn,:);A]; dA = [dA(nn,:);dA];
	for i = 1:nn
  		alfa(i) = 1/(A(i)*A(i+1));
  		dalfa(i,1) = -alfa(i)*(dA(i,1)/A(i)+dA(i+1,1)/A(i+1));
  		dalfa(i,2) = -alfa(i)*(dA(i,2)/A(i)+dA(i+1,2)/A(i+1));
  		sum_alfa = sum_alfa + alfa(i);
  		sum_dalfa(1:2) = sum_dalfa(1:2)+dalfa(i,1:2);
	end
	for i = 1:nn
  		N(i) = alfa(i)/sum_alfa;
  		dNdxi(i,1:2) = (dalfa(i,1:2)-N(i)*sum_dalfa(1:2))/sum_alfa;
	end
end