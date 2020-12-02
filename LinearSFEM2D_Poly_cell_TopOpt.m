% Linear smoothed cell-based finite element method over polytopal mesh for
% topology optimisation
% Author: Amrita, Research scholar, IIT-Madras
% modified by Changkye Lee
close all; clc;

restoredefaultpath;
path(path,'./src');
format long;

% declare input parameters
% Model = getLinearParameters2D(bcType,stressType,numElems,volfr,penal,[eta,zeta],P);
% Model = getLinearParameters2D('Cantilever','plane_sttr',5000,[1e5,0.3],0.5,3.0,0.5,[0.5,0.2],1000);
Model = getLinearParameters2D('MBBbeam','plane_str',5000,[1e5,0.3],0.5,3.0,0.05,[0.4,0.2],1000);
% Model = getLinearParameters2D('Michell','plane_str',2560,[1e5,0.3],0.5,3.0,0.1,[0.4,0.2],1000);
% Model = getLinearParameters2D('Serpentine','plane_str',5000,[1e5,0.3],0.5,4,0.1,[0.4,0.2],1000);
% flags to print node numbers and element numbers
Model.pflag.pMesh = 'no';
Model.pflag.pNode = 'no';
Model.pflag.pElem = 'no';

% load polygonal meshes
Model = srcMeshGeneration2D(Model);

% declare boundary conditions
Model = srcBoundaryConditions2D(Model);

% linear constitutive matrix
Model = srcLinearConstitutive2D(Model);

% optimisation iteration
t0 = cputime;
Model = srcOptimisation(Model);
Model.comp_time = cputime - t0;

% plot optimal configuration
resPath = ['./res/' Model.bcType];
if (~exist(resPath,'dir')) mkdir(resPath); end
saveName = ['LinearSFEM2D_cell_Poly_' Model.bcType '_' num2str(Model.numElems)];
save([resPath '/' saveName '.mat'],'Model');
srcPlotOptimalConfig(Model,resPath,saveName);