function srcPlotOptimalConfig(Model,resPath,saveName)
	figure(2)
	hold on;
	for iel = 1:Model.numElems
% 		wkX = [Model.Xel{iel}; mean(Model.Xel{iel})];
% 		tri = Model.IDel{iel};
        wkX = Model.Xel{iel};
        tri = delaunay(wkX);
		for j = 1:size(tri)
			X = wkX(tri(j,:),:);
			patch(X(:,1),X(:,2),-Model.X(iel),'FaceColor','flat','EdgeColor','none');
		end
	end
	colormap(gray); axis equal; axis tight; axis off;
	hold off;

% 	set(gcf,'PaperUnits','centimeters');
% 	set(gcf,'PaperPosition',[0,0,max(Model.Nodes(:,1))/2,max(Model.Nodes(:,2))/2]);
	saveas(gcf,[resPath '/' saveName '.pdf']);
end
