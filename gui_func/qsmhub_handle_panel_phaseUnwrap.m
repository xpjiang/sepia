%% function output = function_name(input)
%
% Usage:
%
% Input
% --------------
%
% Output
% --------------
%
% Description:
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 
% Date last modified:
%
%
function h = qsmhub_handle_panel_phaseUnwrap(hParent,hFig,h,position)
h.panel_phaseUnwrap = uipanel(hParent,'Title','Total field recovery and phase unwrapping',...
    'position',[position(1) position(2) 0.95 0.2]);
    h.text_phaseUnwrap = uicontrol('Parent',h.panel_phaseUnwrap,'Style','text','String','Phase unwrapping:',...
        'units','normalized','position',[0.01 0.84 0.3 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(hFig,'color'),...
        'tooltip','Select phase unwrapping algorithm');
    h.popup_phaseUnwrap = uicontrol('Parent',h.panel_phaseUnwrap,'Style','popup',...
        'String',{'Laplacian','Laplacian STI suite','Jena','Region growing','Graphcut'},...
        'units','normalized','position',[0.31 0.84 0.4 0.15]); 
%     h.text_unit = uicontrol('Parent',h.panel_phaseUnwrap,'Style','text','String','Output unit:',...
%         'units','normalized','position',[0.01 0.65 0.3 0.15],...
%         'HorizontalAlignment','left',...
%         'backgroundcolor',get(hFig,'color'),...
%         'tooltip','Select unwrapped phase map unit');
%     h.popup_unit = uicontrol('Parent',h.panel_phaseUnwrap,'Style','popup',...
%         'String',{'radHz','ppm','rad','Hz'},...
%         'units','normalized','position',[0.31 0.65 0.4 0.15]);
    h.checkbox_eddyCorrect = uicontrol('Parent',h.panel_phaseUnwrap,'Style','checkbox','String','Bipolar readout eddy current correction',...
        'units','normalized','Position',[0.01 0.41 1 0.2],...
        'backgroundcolor',get(hFig,'color'),...
        'tooltip','Correct the inconsistent phase between odd and even echoes');
    h.checkbox_excludeMask = uicontrol('Parent',h.panel_phaseUnwrap,'Style','checkbox','String','Exclude unreliable voxels',...
        'units','normalized','position',[0.01 0.20 0.6 0.2],...
        'backgroundcolor',get(hFig,'color'));
    h.text_excludeMask = uicontrol('Parent',h.panel_phaseUnwrap,'Style','text','String','Threshold (0-1):',...
        'units','normalized','position',[0.01 0.02 0.3 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(hFig,'color'),...
        'tooltip','Threshold to exclude unreliable voxels [0,1]. Smaller value gives smaller brain volume.');
    h.edit_excludeMask = uicontrol('Parent',h.panel_phaseUnwrap,'Style','edit',...
            'String','0.0009',...
            'units','normalized','position',[0.31 0.02 0.3 0.15],...
            'backgroundcolor','white',...
            'Enable','off');
end