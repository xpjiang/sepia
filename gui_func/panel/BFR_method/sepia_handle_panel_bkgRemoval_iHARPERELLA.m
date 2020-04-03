%% h = sepia_handle_panel_bkgRemoval_iHARPERELLA(hParent,h,position)
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
% Description: This GUI function creates a panel for iHARPERELLA 
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 1 June 2018
% Date modified: 4 April 2020 (v0.8.0)
%
%
function h = sepia_handle_panel_bkgRemoval_iHARPERELLA(hParent,h,position)

%% set default values
defaultMaxiter      = 100;

%% Tooltips
tooltip.bkgRemoval.iHARPERELLA.maxIter = 'Maximum iteration allowed';

%% layout of the panel
nrow        = 4;
rspacing    = 0.01;
ncol        = 2;
cspacing    = 0.01;
[height,bottom,width,left] = sepia_layout_measurement(nrow,rspacing,ncol,cspacing);

%% Parent handle of iHARPERELLA panel

h.bkgRemoval.panel.iHARPERELLA = uipanel(hParent,...
    'Title','iHARPERELLA',...
    'position',position,...
    'backgroundcolor',get(h.fig,'color'),'Visible','off');

%% Chrild of iHARPERELLA panel

    % width of each element in a functional column, in normalised unit of
    % the functional column width
    subwidth(1) = width*0.5;
    subwidth(2) = width-subwidth(1);
    
    % row 1
    % text|edit field pair: maximum number of iterations
    h.bkgRemoval.iHARPERELLA.text.maxIter = uicontrol('Parent',h.bkgRemoval.panel.iHARPERELLA,...
        'Style','text',...
        'String','Max. iterations:',...
        'units','normalized','position',[left(1) bottom(1) subwidth(1) height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip',tooltip.bkgRemoval.iHARPERELLA.maxIter);
    h.bkgRemoval.iHARPERELLA.edit.maxIter = uicontrol('Parent',h.bkgRemoval.panel.iHARPERELLA,...
        'Style','edit',...
        'String',num2str(defaultMaxiter),...
        'units','normalized','position',[left(1)+subwidth(1) bottom(1) subwidth(2) height],...
        'backgroundcolor','white');

%% set callbacks
set(h.bkgRemoval.iHARPERELLA.edit.maxIter,	'Callback', {@EditInputMinMax_Callback,defaultMaxiter,1,1});

end