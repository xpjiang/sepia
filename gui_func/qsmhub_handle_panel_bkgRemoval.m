%% h = qsmhub_handle_panel_bkgRemoval(hParent,hFig,h,position)
%
% Input
% --------------
% hParent       : parent handle of this panel
% hFig          : handle of the GUI
% h             : global structure contains all handles
% position      : position of this panel
%
% Output
% --------------
% h             : global structure contains all new and other handles
%
% Description: This GUI function creates a panel for background field
% removal method control
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 16 April 2018
% Date last modified: 18 April 2018
%
%
function h = qsmhub_handle_panel_bkgRemoval(hParent,hFig,h,position)
h.StepsPanel.bkgRemoval = uipanel(hParent,'Title','Background field removal',...
    'position',[position(1) position(2) 0.95 0.25],...
    'backgroundcolor',get(hFig,'color'));
    h.bkgRemoval.text.bkgRemoval = uicontrol('Parent',h.StepsPanel.bkgRemoval,'Style','text','String','Method:',...
        'units','normalized','position',[0.01 0.85 0.3 0.1],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(hFig,'color'),...
        'tooltip','Select background field removal method');
    h.bkgRemoval.popup.bkgRemoval = uicontrol('Parent',h.StepsPanel.bkgRemoval,'Style','popup',...
        'String',{'LBV','PDF','RESHARP','SHARP','VSHARP STI suite','VSHARP','iHARPERELLA'},...
        'units','normalized','position',[0.31 0.85 0.4 0.1]) ;   
    h.bkgRemoval.checkbox.bkgRemoval = uicontrol('Parent',h.StepsPanel.bkgRemoval,'Style','checkbox',...
        'String','Refine local field by 4th-order polynomial fit',...
        'units','normalized','position',[0.01 0.01 1 0.1],...
        'backgroundcolor',get(hFig,'color'),...
        'tooltip','Enable to remove residual B1 field inhomogeneity',...
        'value',1);
    
    % LBV
    h.bkgRemoval.panel.LBV = uipanel(h.StepsPanel.bkgRemoval,'Title','Laplacian boundary value (LBV)',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'));
        h.bkgRemoval.LBV.text.tol = uicontrol('Parent',h.bkgRemoval.panel.LBV ,'Style','text',...
            'String','Tolerance:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Iteration stopping criteria on the coarsest grid');
        h.bkgRemoval.LBV.edit.tol = uicontrol('Parent',h.bkgRemoval.panel.LBV ,'Style','edit',...
            'String','0.01',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.bkgRemoval.LBV.text.depth = uicontrol('Parent',h.bkgRemoval.panel.LBV ,'Style','text',...
            'String','Depth:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Multigrid level: no. of length scales - the largest length scale is 2^depth * voxel size');
        h.bkgRemoval.LBV.edit.depth = uicontrol('Parent',h.bkgRemoval.panel.LBV ,'Style','edit',...
            'String','5',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
        h.bkgRemoval.LBV.text.peel = uicontrol('Parent',h.bkgRemoval.panel.LBV ,'Style','text',...
            'String','Peel:',...
            'units','normalized','position',[0.01 0.25 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','No. of boundary layers to be peeled off (i.e. disgarded)');
        h.bkgRemoval.LBV.edit.peel = uicontrol('Parent',h.bkgRemoval.panel.LBV ,'Style','edit',...
            'String','2',...
            'units','normalized','position',[0.25 0.25 0.2 0.2],...
            'backgroundcolor','white');
        
    % PDF
    h.bkgRemoval.panel.PDF = uipanel(h.StepsPanel.bkgRemoval,'Title','Projection onto dipole field (PDF)',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.bkgRemoval.PDF.text.tol = uicontrol('Parent',h.bkgRemoval.panel.PDF,'Style','text',...
            'String','Tolerance for CG solver to stop:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.bkgRemoval.PDF.edit.tol = uicontrol('Parent',h.bkgRemoval.panel.PDF,'Style','edit',...
            'String','0.1',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.bkgRemoval.PDF.text.maxIter = uicontrol('Parent',h.bkgRemoval.panel.PDF,'Style','text',...
            'String','Max. iterations:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Maximum iterations allowed');
        h.bkgRemoval.PDF.edit.maxIter = uicontrol('Parent',h.bkgRemoval.panel.PDF,'Style','edit',...
            'String','50',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
        h.bkgRemoval.PDF.text.padSize = uicontrol('Parent',h.bkgRemoval.panel.PDF,'Style','text',...
            'String','Zeropad size:',...
            'units','normalized','position',[0.01 0.25 0.23 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','No. of zeros to be added');
        h.bkgRemoval.PDF.edit.padSize = uicontrol('Parent',h.bkgRemoval.panel.PDF,'Style','edit',...
            'String','40',...
            'units','normalized','position',[0.25 0.25 0.2 0.2],...
            'backgroundcolor','white');
%         h.bkgRemoval.PDF.text.cgSolver = uicontrol('Parent',h.bkgRemoval.panel.PDF,'Style','text',...
%             'String','CG solver',...
%             'units','normalized','position',[0.01 0.25 0.2 0.2],...
%             'HorizontalAlignment','left',...
%             'backgroundcolor',get(hFig,'color'),...
%             'tooltip','Select CG solver');
%         h.bkgRemoval.PDF.popup.cgSolver = uicontrol('Parent',h.bkgRemoval.panel.PDF,'Style','popup',...
%             'String',{'MEDI cgsolver','Matlab pcg'},...
%             'units','normalized','position',[0.25 0.25 0.5 0.2]);
        
    % SHARP
    h.bkgRemoval.panel.SHARP = uipanel(h.StepsPanel.bkgRemoval,'Title','SHARP',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.bkgRemoval.SHARP.text.radius = uicontrol('Parent',h.bkgRemoval.panel.SHARP,'Style','text',...
            'String','Radius (voxel):',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Radius of spherical mean kernel');
        h.bkgRemoval.SHARP.edit.radius = uicontrol('Parent',h.bkgRemoval.panel.SHARP,'Style','edit',...
            'String','4',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.bkgRemoval.SHARP.text.threshold = uicontrol('Parent',h.bkgRemoval.panel.SHARP,'Style','text',...
            'String','Threshold:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Threshold used in truncated SVD');
        h.bkgRemoval.SHARP.edit.threshold = uicontrol('Parent',h.bkgRemoval.panel.SHARP,'Style','edit',...
            'String','0.03',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
    
    % RESHARP    
    h.bkgRemoval.panel.RESHARP = uipanel(h.StepsPanel.bkgRemoval,'Title','Regularisation SHARP',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.bkgRemoval.RESHARP.text.radius = uicontrol('Parent',h.bkgRemoval.panel.RESHARP,'Style','text',...
            'String','Radius (voxel):',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Radius of spherical mean kernel');
        h.bkgRemoval.RESHARP.edit.radius = uicontrol('Parent',h.bkgRemoval.panel.RESHARP,'Style','edit',...
            'String','4',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.bkgRemoval.RESHARP.text.lambda = uicontrol('Parent',h.bkgRemoval.panel.RESHARP,'Style','text',...
            'String','Regularisation parameter:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.bkgRemoval.RESHARP.edit.lambda = uicontrol('Parent',h.bkgRemoval.panel.RESHARP,'Style','edit',...
            'String','0.01',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
        
    % VSHARPSTI    
    h.bkgRemoval.panel.VSHARPSTI = uipanel(h.StepsPanel.bkgRemoval,'Title','STI suite Variable SHARP',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.bkgRemoval.VSHARPSTI.text.smvSize = uicontrol('Parent',h.bkgRemoval.panel.VSHARPSTI,'Style','text',...
            'String','SMV size (mm):',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.bkgRemoval.VSHARPSTI.edit.smvSize = uicontrol('Parent',h.bkgRemoval.panel.VSHARPSTI,'Style','edit',...
            'String','12',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
    
    % VSHARP
    h.bkgRemoval.panel.VSHARP = uipanel(h.StepsPanel.bkgRemoval,'Title','Variable SHARP',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.bkgRemoval.VSHARP.text.maxRadius = uicontrol('Parent',h.bkgRemoval.panel.VSHARP,'Style','text',...
            'String','Max. radius (voxel):',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Maximum radius of spherical mean kernel');
        h.bkgRemoval.VSHARP.edit.maxRadius = uicontrol('Parent',h.bkgRemoval.panel.VSHARP,'Style','edit',...
            'String','10',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.bkgRemoval.VSHARP.text.minRadius = uicontrol('Parent',h.bkgRemoval.panel.VSHARP,'Style','text',...
            'String','Min. radius (voxel):',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Minimum radius of spherical mean kernel');
        h.bkgRemoval.VSHARP.edit.minRadius = uicontrol('Parent',h.bkgRemoval.panel.VSHARP,'Style','edit',...
            'String','3',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
        
    % iHARPERELLA    
    h.bkgRemoval.panel.iHARPERELLA = uipanel(h.StepsPanel.bkgRemoval,'Title','iHARPERELLA',...
        'position',[0.01 0.15 0.95 0.65],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.bkgRemoval.iHARPERELLA.text.maxIter = uicontrol('Parent',h.bkgRemoval.panel.iHARPERELLA,'Style','text',...
            'String','Max. iterations:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Maximum iteration allowed');
        h.bkgRemoval.iHARPERELLA.edit.maxIter = uicontrol('Parent',h.bkgRemoval.panel.iHARPERELLA,'Style','edit',...
            'String','100',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
end