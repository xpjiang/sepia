%% h = qsmhub_handle_panel_qsm(hParent,hFig,h,position)
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
% Description: This GUI function creates a panel for QSM method control
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 16 April 2018
% Date last modified: 18 April 2018
%
%
function h = qsmhub_handle_panel_qsm(hParent,hFig,h,position)
h.StepsPanel.qsm = uipanel(hParent,'Title','QSM','backgroundcolor',get(hFig,'color'),...
    'position',[position(1) position(2) 0.95 0.25]);
    h.qsm.text.qsm = uicontrol('Parent',h.StepsPanel.qsm,'Style','text','String','Method:',...
        'units','normalized','position',[0.01 0.85 0.15 0.1],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(hFig,'color'),...
        'tooltip','Select QSM algorithm');
    h.qsm.popup.qsm = uicontrol('Parent',h.StepsPanel.qsm,'Style','popup',...
        'String',{'TKD','Closed-form solution','STI suite iLSQR','iLSQR','FANSI','Star','MEDI'},...
        'units','normalized','position',[0.31 0.85 0.4 0.1]) ; 
    
    % TKD    
    h.qsm.panel.TKD = uipanel(h.StepsPanel.qsm,'Title','Thresholded k-space division (TKD)',...
        'position',[0.01 0.04 0.95 0.75],...
        'backgroundcolor',get(hFig,'color'),'Visible','on');
        h.qsm.TKD.text.threshold = uicontrol('Parent',h.qsm.panel.TKD,'Style','text',...
            'String','Threshold (0-1):',...
            'units','normalized','position',[0.01 0.75 0.23 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','K-space threshold');
        h.qsm.TKD.edit.threshold = uicontrol('Parent',h.qsm.panel.TKD,'Style','edit',...
            'String','0.15',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');

    % Closed-form solution  
    h.qsm.panel.cfs = uipanel(h.StepsPanel.qsm,'Title','Closed-form solution with L2-norm regularisation',...
        'position',[0.01 0.04 0.95 0.75],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.qsm.cfs.text.lambda = uicontrol('Parent',h.qsm.panel.cfs,'Style','text',...
            'String','Lambda:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Regularisation parameter to control spatial smoothness of QSM');
        h.qsm.cfs.edit.lambda = uicontrol('Parent',h.qsm.panel.cfs,'Style','edit',...
            'String','0.13',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.cfs.checkbox.lambda = uicontrol('Parent',h.qsm.panel.cfs,'Style','checkbox',...
            'String','Self-optimisation by L-curve approach',...
            'units','normalized','position',[0.01 0.5 1 0.2],...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Self estimation of lambda based on L-curve approach');
    
    % iLSQR  
    h.qsm.panel.iLSQR = uipanel(h.StepsPanel.qsm,'Title','Iterative LSQR',...
        'position',[0.01 0.04 0.95 0.75],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.qsm.iLSQR.text.tol = uicontrol('Parent',h.qsm.panel.iLSQR,'Style','text',...
            'String','Tolerance:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Relative tolerance to stop LSQR iteration');
        h.qsm.iLSQR.edit.tol = uicontrol('Parent',h.qsm.panel.iLSQR,'Style','edit',...
            'String','0.001',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.iLSQR.text.maxIter = uicontrol('Parent',h.qsm.panel.iLSQR,'Style','text',...
            'String','Max. iterations:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Maximum iterations allowed');
        h.qsm.iLSQR.edit.maxIter = uicontrol('Parent',h.qsm.panel.iLSQR,'Style','edit',...
            'String','100',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.iLSQR.text.lambda = uicontrol('Parent',h.qsm.panel.iLSQR,'Style','text',...
            'String','Lambda:',...
            'units','normalized','position',[0.01 0.25 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Regularisation parameter to control spatial smoothness of QSM');
        h.qsm.iLSQR.edit.lambda = uicontrol('Parent',h.qsm.panel.iLSQR,'Style','edit',...
            'String','0.13',...
            'units','normalized','position',[0.25 0.25 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.iLSQR.checkbox.lambda = uicontrol('Parent',h.qsm.panel.iLSQR,'Style','checkbox',...
            'String','Self-optimisation by L-curve approach',...
            'units','normalized','position',[0.01 0.01 1 0.2],...
            'backgroundcolor',get(hFig,'color'),...
            'tooltip','Self estimation of lambda based on L-curve approach');
        
    % STI suite iLSQR  
    h.qsm.panel.STIiLSQR = uipanel(h.StepsPanel.qsm,'Title','STI suite iLSQR',...
        'position',[0.01 0.04 0.95 0.75],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.qsm.STIiLSQR.text.threshold = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','text',...
            'String','Threshold:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.STIiLSQR.edit.threshold = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','edit',...
            'String','0.01',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.STIiLSQR.text.maxIter = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','text',...
            'String','Iterations:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.STIiLSQR.edit.maxIter = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','edit',...
            'String','100',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.STIiLSQR.text.tol1 = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','text',...
            'String','Tolerance 1:',...
            'units','normalized','position',[0.01 0.25 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.STIiLSQR.edit.tol1 = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','edit',...
            'String','0.01',...
            'units','normalized','position',[0.25 0.25 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.STIiLSQR.text.tol2 = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','text',...
            'String','Tolerance 2:',...
            'units','normalized','position',[0.5 0.25 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.STIiLSQR.edit.tol2 = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','edit',...
            'String','0.001',...
            'units','normalized','position',[0.75 0.25 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.STIiLSQR.text.padSize = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','text',...
            'String','Pad size:',...
            'units','normalized','position',[0.01 0.01 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.STIiLSQR.edit.padSize = uicontrol('Parent',h.qsm.panel.STIiLSQR,'Style','edit',...
            'String','12',...
            'units','normalized','position',[0.25 0.01 0.2 0.2],...
            'backgroundcolor','white');
    
    % FANSI
    h.qsm.panel.FANSI = uipanel(h.StepsPanel.qsm,'Title','FANSI',...
        'position',[0.01 0.04 0.95 0.75],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.qsm.FANSI.text.tol = uicontrol('Parent',h.qsm.panel.FANSI,'Style','text',...
            'String','Tolerance:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.FANSI.edit.tol = uicontrol('Parent',h.qsm.panel.FANSI,'Style','edit',...
            'String','1',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.FANSI.text.lambda = uicontrol('Parent',h.qsm.panel.FANSI,'Style','text',...
            'String','Gradient L1 penalty:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.FANSI.edit.lambda = uicontrol('Parent',h.qsm.panel.FANSI,'Style','edit',...
            'String','3e-5',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.FANSI.text.mu = uicontrol('Parent',h.qsm.panel.FANSI,'Style','text',...
            'String','Gradient consistency:',...
            'units','normalized','position',[0.5 0.5 0.23 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.FANSI.edit.mu = uicontrol('Parent',h.qsm.panel.FANSI,'Style','edit',...
            'String','5e-5',...
            'units','normalized','position',[0.75 0.5 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.FANSI.text.mu2 = uicontrol('Parent',h.qsm.panel.FANSI,'Style','text',...
            'String','Fidelity consistency:',...
            'units','normalized','position',[0.5 0.75 0.23 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.FANSI.edit.mu2 = uicontrol('Parent',h.qsm.panel.FANSI,'Style','edit',...
            'String','1',...
            'units','normalized','position',[0.75 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.FANSI.text.maxIter = uicontrol('Parent',h.qsm.panel.FANSI,'Style','text',...
            'String','Max. iterations:',...
            'units','normalized','position',[0.01 0.25 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.FANSI.edit.maxIter = uicontrol('Parent',h.qsm.panel.FANSI,'Style','edit',...
            'String','50',...
            'units','normalized','position',[0.25 0.25 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.FANSI.text.solver = uicontrol('Parent',h.qsm.panel.FANSI,'Style','text',...
            'String','Solver:',...
            'units','normalized','position',[0.01 0.01 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.FANSI.popup.solver = uicontrol('Parent',h.qsm.panel.FANSI,'Style','popup',...
            'String',{'Linear','Non-linear'},...
            'units','normalized','position',[0.25 0.01 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.FANSI.text.constraints = uicontrol('Parent',h.qsm.panel.FANSI,'Style','text',...
            'String','Constraint:',...
            'units','normalized','position',[0.5 0.01 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.FANSI.popup.constraints = uicontrol('Parent',h.qsm.panel.FANSI,'Style','popup',...
            'String',{'TV','TGV'},...
            'units','normalized','position',[0.75 0.01 0.2 0.2],...
            'backgroundcolor','white');
        
    % Star
    h.qsm.panel.Star = uipanel(h.StepsPanel.qsm,'Title','Star',...
        'position',[0.01 0.04 0.95 0.75],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.qsm.Star.text.padSize = uicontrol('Parent',h.qsm.panel.Star,'Style','text',...
            'String','Pad size:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.Star.edit.padSize = uicontrol('Parent',h.qsm.panel.Star,'Style','edit',...
            'String','12',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        
    % MEDI
    h.qsm.panel.MEDI = uipanel(h.StepsPanel.qsm,'Title','Morphology-enabled dipole inversion (MEDI)',...
        'position',[0.01 0.04 0.95 0.75],...
        'backgroundcolor',get(hFig,'color'),'Visible','off');
        h.qsm.MEDI.text.lambda = uicontrol('Parent',h.qsm.panel.MEDI,'Style','text',...
            'String','lambda:',...
            'units','normalized','position',[0.01 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.MEDI.edit.lambda = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
            'String','1000',...
            'units','normalized','position',[0.25 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.MEDI.text.zeropad = uicontrol('Parent',h.qsm.panel.MEDI,'Style','text',...
            'String','Zeropad:',...
            'units','normalized','position',[0.5 0.75 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.MEDI.edit.zeropad = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
            'String','0',...
            'units','normalized','position',[0.75 0.75 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.MEDI.text.weightData = uicontrol('Parent',h.qsm.panel.MEDI,'Style','text',...
            'String','Data weight:',...
            'units','normalized','position',[0.01 0.5 0.2 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.MEDI.edit.weightData = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
            'String','1',...
            'units','normalized','position',[0.25 0.5 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.MEDI.text.weightGradient = uicontrol('Parent',h.qsm.panel.MEDI,'Style','text',...
            'String','Gradient weight:',...
            'units','normalized','position',[0.5 0.5 0.24 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.MEDI.edit.weightGradient = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
            'String','1',...
            'units','normalized','position',[0.75 0.5 0.2 0.2],...
            'backgroundcolor','white');
        h.qsm.MEDI.checkbox.smv = uicontrol('Parent',h.qsm.panel.MEDI,'Style','checkbox',...
            'String','SMV, radius',...
            'units','normalized','position',[0.01 0.25 0.24 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.MEDI.edit.smv_radius = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
            'String','5',...
            'units','normalized','position',[0.25 0.25 0.2 0.2],...
            'backgroundcolor','white','enable','off');
        h.qsm.MEDI.checkbox.merit = uicontrol('Parent',h.qsm.panel.MEDI,'Style','checkbox',...
            'String','Merit',...
            'units','normalized','position',[0.5 0.25 0.24 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.MEDI.checkbox.lambda_csf = uicontrol('Parent',h.qsm.panel.MEDI,'Style','checkbox',...
            'String','Lambda CSF:',...
            'units','normalized','position',[0.01 0.01 0.24 0.2],...
            'HorizontalAlignment','left',...
            'backgroundcolor',get(hFig,'color'));
        h.qsm.MEDI.edit.lambda_csf = uicontrol('Parent',h.qsm.panel.MEDI,'Style','edit',...
            'String','100',...
            'units','normalized','position',[0.25 0.01 0.2 0.2],...
            'backgroundcolor','white','enable','off');
end