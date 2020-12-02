function Model = getLinearParameters2D(bcType,stressType,numElems,matParams,volfr,penal,rmin,ocParam,P)
	Model.bcType = bcType;
	Model.stressType = stressType;
	Model.numElems = numElems;
	Model.matParams = matParams;
	Model.volfr = volfr;
	Model.penal = penal;
	Model.rmin = rmin;
	Model.ocParam = ocParam;
	Model.P = P;
end