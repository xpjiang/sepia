%% h = qsmhub_handle_panel_bkgRemoval_LBV(hParent,h,position)
%
% Input
% --------------
% hParent       : parent handle of this panel
% h             : global structure contains all handles
% position      : position of this panel
%
% Output
% --------------
% h             : global structure contains all new and other handles
%
% Description: This GUI function creates a panel for LBV method
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 1 June 2018
% Date last modified: 
%
%
function h = qsmhub_handle_panel_bkgRemoval_LBV(hParent,h,position)

%% Parent handle of LBV panel children

h.bkgRemoval.panel.LBV = uipanel(hParent,...
    'Title','Laplacian boundary value (LBV)',...
    'position',position,...
    'backgroundcolor',get(h.fig,'color'));

%% Children of LBV panel
    
    % text|edit field pair: tolerance
    h.bkgRemoval.LBV.text.tol = uicontrol('Parent',h.bkgRemoval.panel.LBV ,...
        'Style','text',...
        'String','Tolerance:',...
        'units','normalized','position',[0.01 0.75 0.2 0.2],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Iteration stopping criteria on the coarsest grid');
    h.bkgRemoval.LBV.edit.tol = uicontrol('Parent',h.bkgRemoval.panel.LBV ,...
        'Style','edit',...
        'String','0.01',...
        'units','normalized','position',[0.25 0.75 0.2 0.2],...
        'backgroundcolor','white');
    
    % text|edit field pair: depth
    h.bkgRemoval.LBV.text.depth = uicontrol('Parent',h.bkgRemoval.panel.LBV ,...
        'Style','text',...
        'String','Depth:',...
        'units','normalized','position',[0.01 0.5 0.2 0.2],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Multigrid level: no. of length scales - the largest length scale is 2^depth * voxel size');
    h.bkgRemoval.LBV.edit.depth = uicontrol('Parent',h.bkgRemoval.panel.LBV ,...
        'Style','edit',...
        'String','5',...
        'units','normalized','position',[0.25 0.5 0.2 0.2],...
        'backgroundcolor','white');

    % text|edit field pair: peel
    h.bkgRemoval.LBV.text.peel = uicontrol('Parent',h.bkgRemoval.panel.LBV ,...
        'Style','text',...
        'String','Peel:',...
        'units','normalized','position',[0.01 0.25 0.2 0.2],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','No. of boundary layers to be peeled off (i.e. disgarded)');
    h.bkgRemoval.LBV.edit.peel = uicontrol('Parent',h.bkgRemoval.panel.LBV ,...
        'Style','edit',...
        'String','2',...
        'units','normalized','position',[0.25 0.25 0.2 0.2],...
        'backgroundcolor','white');

%% Set callbacks
set(h.bkgRemoval.LBV.edit.depth,    'Callback', {@EditInputMinMax_Callback,1,-1});
set(h.bkgRemoval.LBV.edit.peel,     'Callback', {@EditInputMinMax_Callback,1,0});
set(h.bkgRemoval.LBV.edit.tol,      'Callback', {@EditInputMinMax_Callback,0,0});

end