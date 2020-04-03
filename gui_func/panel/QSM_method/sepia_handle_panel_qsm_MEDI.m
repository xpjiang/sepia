%% h = sepia_handle_panel_qsm_MEDI(hParent,h,position)
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
% Description: This GUI function creates a panel for FANSI method
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 1 June 2018
% Date modified: 4 April 2020 (v0.8.0)
%
%
function h = sepia_handle_panel_qsm_MEDI(hParent,h,position)

%% set default values
defaultWeightGradient   = 1;
defaultLambda           = 1000;
defaultZeropad          = 0;
defaultWeightData       = 1;
defaultSMV              = 5;
defaultLambda_csf       = 100;
defaultPercentage       = 90;

%% Tooltips
tooltip.qsm.MEDI.lambda   	= 'Regularisation parameter';
tooltip.qsm.MEDI.zeropad	= 'Zero padding after the last element';
tooltip.qsm.MEDI.weightData	= '0: uniform weighting; 1: SNR weighting';
tooltip.qsm.MEDI.percentage	= 'Percentage of voxels considered to be edges (percentage option in MEDI)';

%% layout of the panel
nrow        = 4;
rspacing    = 0.01;
ncol        = 2;
cspacing    = 0.01;
[height,bottom,width,left] = sepia_layout_measurement(nrow,rspacing,ncol,cspacing);

%% Parent handle of MEDI panel children

h.qsm.panel.MEDI = uipanel(hParent,...
    'Title','Morphology-enabled dipole inversion (MEDI+0)',...
    'position',position,...
    'backgroundcolor',get(h.fig,'color'),'Visible','off');

%% Children of MEDI panel

    % width of each element in a functional column, in normalised unit of
    % the functional column width
    subwidth(1) = width*0.5;
    subwidth(2) = width-subwidth(1);
    
%     col_width = [0.2, 0.2];
    % text|edit field pair: regularisation parameter
    h.qsm.MEDI.text.lambda = uicontrol('Parent',h.qsm.panel.MEDI,...
        'Style','text',...
        'String','lambda:',...
        'units','normalized','position',[left(1) bottom(1) subwidth(1) height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'Tooltip',tooltip.qsm.MEDI.lambda);
    h.qsm.MEDI.edit.lambda = uicontrol('Parent',h.qsm.panel.MEDI,...
        'Style','edit',...
        'String',num2str(defaultLambda),...
        'units','normalized','position',[left(1)+subwidth(1) bottom(1) subwidth(2) height],...
        'backgroundcolor','white');

    % text|edit field pair: size of zero padding
    h.qsm.MEDI.text.zeropad = uicontrol('Parent',h.qsm.panel.MEDI,...
        'Style','text',...
        'String','Zeropad:',...
        'units','normalized','position',[left(2) bottom(1) subwidth(1) height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'Tooltip',tooltip.qsm.MEDI.zeropad);
    h.qsm.MEDI.edit.zeropad = uicontrol('Parent',h.qsm.panel.MEDI,...
        'Style','edit',...
        'String',num2str(defaultZeropad),...
        'units','normalized','position',[left(2)+subwidth(1) bottom(1) subwidth(2) height],...
        'backgroundcolor','white');

    % text|edit field pair: weighting of phase data
    h.qsm.MEDI.text.weightData = uicontrol('Parent',h.qsm.panel.MEDI,...
        'Style','text',...
        'String','Data weight Mode (0/1):',...
        'units','normalized','position',[left(1) bottom(2) subwidth(1) height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'Tooltip',tooltip.qsm.MEDI.weightData);
    h.qsm.MEDI.edit.weightData = uicontrol('Parent',h.qsm.panel.MEDI,...
        'Style','edit',...
        'String',num2str(defaultWeightData),...
        'units','normalized','position',[left(1)+subwidth(1) bottom(2) subwidth(2) height],...
        'backgroundcolor','white');
    
    % text|edit field pair: weighting of gradient of magnitude data
    h.qsm.MEDI.text.percentage = uicontrol('Parent',h.qsm.panel.MEDI,'Style','text',...
        'String','Edge mask threshold (%)',...
        'units','normalized','position',[left(2) bottom(2) subwidth(1) height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'Tooltip',tooltip.qsm.MEDI.percentage);
    h.qsm.MEDI.edit.percentage = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
        'String',num2str(defaultPercentage),...
        'units','normalized','position',[left(2)+subwidth(1) bottom(2) subwidth(2) height],...
        'Enable','on',...
        'backgroundcolor','white');

    % checkbox|edit field pair: SMV size
    h.qsm.MEDI.checkbox.smv = uicontrol('Parent',h.qsm.panel.MEDI,'Style','checkbox',...
        'String','SMV, radius',...
        'units','normalized','position',[left(1) bottom(3) subwidth(1) height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'));
    h.qsm.MEDI.edit.smv_radius = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
        'String',num2str(defaultSMV),...
        'units','normalized','position',[left(1)+subwidth(1) bottom(3) subwidth(2) height],...
        'backgroundcolor','white','enable','off');

    % checkbox: Merit
    h.qsm.MEDI.checkbox.merit = uicontrol('Parent',h.qsm.panel.MEDI,'Style','checkbox',...
        'String','Merit',...
        'units','normalized','position',[left(2) bottom(3) width height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'));

    % checkbox|edit field pair: regulariation of CSF
    h.qsm.MEDI.checkbox.lambda_csf = uicontrol('Parent',h.qsm.panel.MEDI,'Style','checkbox',...
        'String','Lambda CSF:',...
        'units','normalized','position',[left(1) bottom(4) subwidth(1) height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'));
    h.qsm.MEDI.edit.lambda_csf = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
        'String',num2str(defaultLambda_csf),...
        'units','normalized','position',[left(1)+subwidth(1) bottom(4) subwidth(2) height],...
        'backgroundcolor','white','enable','off');
    
    % text|edit field pair: weighting of gradient of magnitude data
    h.qsm.MEDI.text.weightGradient = uicontrol('Parent',h.qsm.panel.MEDI,'Style','text',...
        'String','Gradient weight mode:',...
        'units','normalized','position',[left(2) bottom(1) subwidth(1) height],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'visible','off');
    h.qsm.MEDI.edit.weightGradient = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
        'String',num2str(defaultWeightGradient),...
        'units','normalized','position',[left(2)+subwidth(1) bottom(1) subwidth(2) height],...
        'Enable','off',...
        'backgroundcolor','white',...
        'visible','off');

%% set callback functions
set(h.qsm.MEDI.edit.lambda_csf,     'Callback', {@EditInputMinMax_Callback,defaultLambda_csf,       0,0});
set(h.qsm.MEDI.edit.smv_radius,     'Callback', {@EditInputMinMax_Callback,defaultSMV,              0,0});
set(h.qsm.MEDI.edit.weightGradient, 'Callback', {@EditInputMinMax_Callback,defaultWeightGradient,   0,0});
set(h.qsm.MEDI.edit.weightData,     'Callback', {@EditInputMinMax_Callback,defaultWeightData,       1,0,1});
set(h.qsm.MEDI.edit.zeropad,        'Callback', {@EditInputMinMax_Callback,defaultZeropad,          1,0});
set(h.qsm.MEDI.edit.lambda,         'Callback', {@EditInputMinMax_Callback,defaultLambda,           0,0});
set(h.qsm.MEDI.edit.percentage,     'Callback', {@EditInputMinMax_Callback,defaultPercentage,     	0,0,100});

set(h.qsm.MEDI.checkbox.smv,       	'Callback', {@CheckboxEditPair_Callback,h.qsm.MEDI.edit.smv_radius,1});
set(h.qsm.MEDI.checkbox.lambda_csf,	'Callback', {@CheckboxEditPair_Callback,h.qsm.MEDI.edit.lambda_csf,1});


end