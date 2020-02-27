%% function [chi, lamdaOptimal] = qsmMacro(localField,mask,matrixSize,voxelSize,varargin)
%
% Usage: 
%       chi = qsmMacro(localField,mask,matrixSize,voxelSize,...
%               'method','TKD','threshold',0.15);
%       chi = qsmMacro(localField,mask,matrixSize,voxelSize,...
%               'method','ClosedFormL2','lambda',0.1,'optimise',false);
%       chi = qsmMacro(localField,mask,matrixSize,voxelSize,...
%               'method','iLSQR','lambda',0.1,'optimise',false,'tol',1e-3,...
%               'iteration',100,'weight',wmap,'initGuess',initGuessmap);
%       chi = qsmMacro(localField,mask,matrixSize,voxelSize,...
%               'method','STISuiteiLSQR','threshold',0.01,'iteration',100,...
%               'tol_step1',0.01,'tol_step2',0.001,'b0dir',[0,0,1],'TE',1,...
%               'B0',3,'padsize',[4,4,4]);
%       chi = qsmMacro(localField,mask,matrixSize,voxelSize,...
%               'method','FANSI','tol',1,'lambda',3e-5,'mu',5e-5,'iteration',50,'weight',wmap,...
%               'tgv','nonlinear');
%       chi = qsmMacro(totalField,mask,matrixSize,voxelSize,...
%               'method','SSVSHARP','tol',tol,'lambda',lambda,'iteration',maxiter,'magnitude',magn,...
%               'vkernel',Kernel_Sizes);
%       chi = qsmMacro(totalField,mask,matrixSize,voxelSize,...
%               'method','Star','b0dir',[0,0,1],'TE',1,'B0',3,'padsize',[4,4,4]);
%
% Input
% --------------
% localField    : Local (tissue) field map, in Hz
% mask          : brain (signal) mask
% matrixSize    : matrix size of the 3D data
% voxelSize     : spatial resolution of the data, in mm
%
% Output
% --------------
% chi           : Magnetic susceptibility map, in ppm
% lamdaOptimal  : optimal regularisation parameter (optional)
%
% Description: Wrapper for QSM inversion problem (default using TKD)
%   Flags:
%       'method'        : QSM method, 
%                          'TKD', 'ClosedFormL2', 'iLSQR', 'FANSI',
%                          'ssvsharp', 'STISuiteiLSQR', 'Star'
%       'b0dir'         : B0 direction
%
%       TKD
%       ----------------
%       'threshold'     : threshold for TKD
%
%       ClosedFormL2
%       ----------------           
%       'lambda'        : regularisation value
%       'optimise'      : self-define regularisation based on curvature of 
%                         L-curve
%
%       iLSQR
%       ----------------
%       'lambda'        : regularisation value
%       'tol'           : error tolerance
%       'iteration' 	: no. of maximum iteration for iLSQR
%       'weight'    	: weighting of error computation
%       'initGuess'     : initial guess for iLSQR
%       'optimise'      : self-define regularisation based on curvature of 
%                         L-curve
%
%       STISuiteiLSQR
%       ----------------
%       'threshold'     : threshold for STISuiteiLSQR
%       'iteration' 	: no. of maximum iteration for iLSQR
%       'tol_step1'     : error tolerance
%       'tol_step2'     : error tolerance
%       'b0dir'         : main magnetic field direction
%       'TE'            : echo time
%       'fieldStrength' : magntic field strength of the scanner
%       'padsize'       : size for padarray to increase numerical accuracy
%
%       FANSI
%       ----------------
%       'lambda'        : user defined regularisation parameter for gradient L1 penalty
%       'mu'            : user defined regularisation parameter for gradient consistency 
%       'tol'           : tolerance for iteration
%       'iteration'     : maxlocalFieldimum number of iterations
%       'weight'        : weighting of error computation
%       'linear'        : linear solver
%       'nonlinear'     : nonlinear solver
%       'tgv'           : Total generalised variation constraint
%       'tv'            : Total variation constraints
%
%       Star
%       ----------------
%       'padsize'        : size for padarray to increase numerical accuracy
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 28 June 2017
% Date modified: 9 April 2018
% Date modified: 1 April 2019
% Date modified: 5 June 2019
% Date modified: 27 Feb 2020 (v0.8.0)
%
function [chi, lamdaOptimal] = QSMMacro(localField,mask,matrixSize,voxelSize,varargin)

gyro = 42.57747892;

lamdaOptimal    = [];
voxelSize       = double(voxelSize(:).');
matrixSize      = double(matrixSize(:).');

%% Parsing argument input flags
if ~isempty(varargin)
    for kvar = 1:length(varargin)
        [b0,b0dir,te] = parse_varargin_QSMmacro(varargin);
        if strcmpi(varargin{kvar},'method')
            switch lower(varargin{kvar+1})
                case 'tkd'
                    method = 'TKD';
                    [thre_tkd, ~] = parse_varargin_TKD(varargin);
                    break
                    
                case 'closedforml2'
                    method = 'CFL2';
                    [lambda,optimise,~] = parse_varargin_CFL2norm(varargin);
                    break
                    
                case 'ilsqr'
                    method = 'iLSQR';
                    [lambda, tol, maxiter, wmap, initGuess, optimise, ~] = parse_varargin_iLSQR(varargin);
                    if isempty(wmap)
                        wmap = ones(matrixSize);
                    end
                    if isempty(initGuess)
                        initGuess = zeros(matrixSize);
                    end
                    break
                    
                case 'stisuiteilsqr'
                    method = 'STISuiteiLSQR';
                    algoPara = parse_varargin_STISuiteiLSQRv3(varargin);
                    algoPara.H          = b0dir(:).';
                    algoPara.TE         = te*1e3;
                    algoPara.B0         = b0;
                    algoPara.voxelsize  = double(voxelSize(:).');
                    break
                    
                case 'fansi'
                    method = 'FANSI';
%                     [mu1,mu2,alpha1,tol,maxiter,wmap,solver,constraint,b0dir]=parse_varargin_FANSI(varargin);
                    [mu1,mu2,alpha1,wmap,options,~]=parse_varargin_FANSI(varargin);
                    
                case 'ssvsharp'
                    method = 'SSVSHARP';
                    [lambda,magn,tol,maxiter,Kernel_Sizes,~]=parse_varargin_SSQSM(varargin);
                    
                case 'star'
                    method = 'Star';
                    [padSize] = parse_varargin_Star(varargin);
                    
                case 'medi_l1'
                    method = 'MEDI_L1';
                    [N_std,magn,lambda,pad,~,CF,~,isMerit,isSMV,radius,wData,wGrad,Debug_Mode,lam_CSF,Mask_CSF] = parse_varargin_MEDI_L1(varargin);
                    
                case 'ndi'
                    method = 'NDI';
                    [tol,stepSize,maxiter,wmap,~] = parse_varargin_NDI(varargin);
                    
            end
        end
    end
else
    % predefine paramater: if no varargin, use TKD
    disp('No method selected. Using default setting...');
    method = 'TKD';
    thre_tkd = 0.15;
end

disp(['The following QSM algorithm will be used: ' method]);

%% zero padding for odd number dimension

% essential input
localField  = double(zeropad_odd_dimension(localField,'pre'));
mask        = double(zeropad_odd_dimension(mask,'pre'));

% additional input
if exist('wmap','var')
    wmap   = double(zeropad_odd_dimension(wmap,'pre'));
end
if exist('magn','var')
    magn   = double(zeropad_odd_dimension(magn,'pre'));
end
if exist('N_std','var')
    N_std   = double(zeropad_odd_dimension(N_std,'pre'));
end
if exist('initGuess','var')
    initGuess   = double(zeropad_odd_dimension(initGuess,'pre'));
end
if exist('Mask_CSF','var')
    Mask_CSF   = double(zeropad_odd_dimension(Mask_CSF,'pre'));
end
matrixSize_new = size(localField);

%% QSM algorithm

% add path
sepia_addpath(method);

% General steps as follow:
% 1. input unit converted for optimal performance (if neccessary)
% 2. main QSM algorithm
% 3. convert output unit to ppm
switch method
    case 'TKD'
        
        chi = qsmTKD(localField,mask,matrixSize_new,voxelSize,'threshold',thre_tkd,'b0dir',b0dir);
        
        chi = chi/(b0*gyro);
    
    case 'CFL2'
        
        [chi, lamdaOptimal] = qsmClosedFormL2(localField,mask,matrixSize_new,voxelSize,...
            'lambda',lambda,'optimise',optimise,'b0dir',b0dir);
        
        chi = chi/(b0*gyro);
        
    case 'iLSQR'
        
        chi = qsmIterativeLSQR(localField,mask,matrixSize_new,voxelSize,...
            'lambda',lambda,'tol',tol,'iteration',maxiter,'weight',wmap,...
            'initGuess',initGuess,'optimise',optimise,'b0dir',b0dir);
        
        chi = chi/(b0*gyro);
        
    case 'STISuiteiLSQR'
        
        % The order of local field values doesn't affect the result of chi  
        % in STI suite v3 implementation, i.e. 
        % chi = method(localField,...) = method(localField*C,...)/C, where
        % C is a constant.
        % Therefore, because of the scaling factor in their implementation,
        % the local field map is converted to rad
        localField = localField * 2*pi * (algoPara.TE*1e-3); 
        
        % double precision is requried for this function
%         localField  = double(localField);
%         mask        = double(mask);
        chi = QSM_iLSQR(localField,mask,'params',algoPara);
        
    case 'FANSI'
        
        % FANSI default parameters are optimised for ppm
        localField = localField/(b0*gyro);
        
        noise = 0;
        
        chi = FANSI_4sepia(localField,wmap,voxelSize,alpha1,mu1,noise,options,b0dir);
        chi = chi .* mask;

    case 'SSVSHARP'
        
        chi = qsmSingleStepVSHARP(localField,mask,matrixSize_new,voxelSize,...
            'tol',tol,'lambda',lambda,'iteration',maxiter,'magnitude',magn,...
            'b0dir',b0dir,'vkernel',Kernel_Sizes);
        
        chi = chi/(b0*gyro);
        
    case 'Star'
        
        % Unlike the iLSQR implementation, the order of local field map
        % values will affect the Star-QSM result, i.e. 
        % chi = method(localField,...) ~= method(localField*C,...)/C, where
        % C is a constant. Lower order of local field magnitude will more 
        % likely produce chi map with streaking artefact. 
        % In the STI_Templates.m example, Star-QSM expecting local field in 
        % the unit of rad. However, value of the field map in rad will 
        % vary with echo time. Therefore, data acquired with short
        % TE will be prone to streaking artefact. To mitigate this
        % potential problem, local field map is converted from Hz to radHz
        % here and the resulting chi will be normalised by the same factor 
        % 
        localField = localField * 2*pi;
        
        chi = QSM_star(localField,mask,'TE',te*1e3,'B0',b0,'H',b0dir,'padsize',padSize,'voxelsize',voxelSize);
        
        chi = chi * te;
        
    case 'MEDI_L1'
        
        % MEDI input expects local field in rad
        localField = localField*2*pi*te;
        
        chi = MEDI_L1_4sepia(localField,mask,matrixSize_new,voxelSize,...
            'lambda',lambda,'pad',pad,'TE',te,'CF',CF,'b0dir',b0dir,'merit',isMerit,...
            'smv',isSMV,'radius',radius,'data_weighting',wData,...
            'gradient_weighting',wGrad,'lam_CSF',lam_CSF,...
            'noisestd',N_std,'magnitude',magn,'Mask_CSF',Mask_CSF);
        
    case 'NDI'
        
        % NDI default parameters are relative so okay for ppm
        localField = localField/(b0*gyro);
        
        chi = NDI(localField,mask,voxelSize,'b0dir',b0dir,'weight',wmap,...
                  'iteration',maxiter,'stepsize',stepSize,'tol',tol);
end

% remove zero padding 
chi = double(zeropad_odd_dimension(chi,'post',matrixSize));

end

