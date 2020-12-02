function Model = srcMeshGeneration2D(Model)
	% load mat file
	mesh = load(['./model/' Model.bcType '/' ...
		Model.bcType '_' num2str(Model.numElems) '.mat']);
	if strcmp(Model.bcType,'Cantilever')
		Model.Nodes = mesh.node; Model.Elements = mesh.element;
	else
		Model.Nodes = mesh.Node; Model.Elements = mesh.Element;
		Model.BCNodes = mesh.Supp; Model.LoadNodes = mesh.Load;
	end
	Model.Vertices = Model.Elements;
	[Model.numNodes,DIM] = size(Model.Nodes);
	Model.DOFs = DIM*Model.numNodes;

	if strcmp(Model.pflag.pMesh,'yes')
    	% plot the new mesh...
    	clf; axis equal; axis on; hold on;
    	Element = Model.Vertices(1:Model.numElems)';                 %Only plot the first block
    	MaxNVer = max(cellfun(@numel,Element));      %Max. num. of vertices in mesh
    	PadWNaN = @(E) [E NaN(1,MaxNVer-numel(E))];  %Pad cells with NaN
    	ElemMat = cellfun(PadWNaN,Element,'UniformOutput',false);
    	ElemMat = vertcat(ElemMat{:});               %Create padded element matrix
    	patch('Faces',ElemMat,'Vertices',Model.Nodes,'FaceColor','w'); pause(1e-6)
    
    	if strcmp(Model.pflag.pNode,'yes')
        	% plot node numbers
        	for in = 1:Model.numNodes
            	xc = Model.Nodes(in,1) + 0.01 ;
            	yc = Model.Nodes(in,2) - 0.01 ;
            	text(xc,yc,num2str(in),'color','blue');
        	end
    	end
    
    	if strcmp(Model.pflag.pElem,'yes')
        	% print element numbers
        	for iel = 1:model.numElems
            	econ = Model.Elements{iel};
            	nod = Model.Nodes(econ,:) ;
            	text(mean(nod(:,1)),mean(nod(:,2)),num2str(iel),'color','red') ;
        	end
    	end
	end
end