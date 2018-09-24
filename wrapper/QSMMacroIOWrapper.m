%% chi = qsmMacroIOWrapper(inputDir,outputDir,varargin)
%
% Input
% --------------
% inputDir              : input directory contains NIfTI (*localfield*, *magn* and *fieldmapsd*) files 
% outputDir             : output directory that stores the output (susceptibility map)
% varargin ('Name','Value' pair)
% ---------
% 'mask'                : mask file (in NIfTI format) full name 
% 'QSM'                 : QSM method (default: 'TKD')
% 'QSM_threshold'       : threshold of TKD (defualt: 0.15) 
% 'QSM_lambda'          : regularisation parameter of TKD, CFL2, iLSQR, FANSI and MEDI (overloaded) (default: 0.13)
% 'QSM_optimise'        : boolean automatically estimate regularisation parameter based on L-curve approach of CFL2 and iLSQR (overloaded) (default: false)
% 'QSM_tol'             : tolerance of iLSQR and FANSI (overloaded)(default: 1e-3)
% 'QSM_iteration'       : no. of iterations of iLSQR, STISuiteiLQR and FANSI (overloaded) (default: 50)
% 'QSM_tol1'            : step 1 tolerance of STISuiteiLQR (default: 0.01)
% 'QSM_tol2'            : step 2 tolerance of STISuiteiLQR (default: 0.001)
% 'QSM_padsize'         : pad size of STISuiteiLQR (default: [4,4,4])
% 'QSM_mu'              : regularisation parameter of data consistency of FANSI (default: 5e-5)
% 'QSM_zeropad'         : size of zero-padding of MEDI (default: 0)
% 'QSM_wData'           : weighting of data of MEDI (default: 1)
% 'QSM_wGradient'       : weighting of gradient regularisation of MEDI (default: 1)
% 'QSM_radius'          : radius for the spherical mean value operator of MEDI (default: 5)
% 'QSM_isSMV'           : boolean using spherical mean value operator of MEDI (default: false)
% 'QSM_merit'           : boolean model error reduction through iterative tuning of MEDI (default: false)
% 'QSM_isLambdaCSF'     : boolen automatic zero reference (MEDI+0) (required CSF mask) (default: false)
% 'QSM_lambdaCSF'       : regularisation parameter of CSF reference of MEDI (default: 100)
% varargin ('flag')
% 'linear'              : linear solver for FANSI (default)
% 'non-linear'          : non-linear solver for FANSI
% 'TV'                  : Total variation constraint for FANSI (default)
% 'TGV'                 : total generalisaed variation for FANSI 
%
% Output
% --------------
% chi                   : quantitative susceptibility map (in ppm)
%
% Description: This is a wrapper of BackgroundRemovalMac1ro.m which has the following objeectives:
%               (1) matches the input format of qsm_hub.m
%               (2) save the results in NIfTI format
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 17 April 2018
% Date last modified: 26 August 2018
%
%
function chi = QSMMacroIOWrapper(input,output,maskFullName,varargin)
%% add general Path
sepia_addpath

%% define variables
prefix = 'squirrel_';
gyro = 42.57747892;
isInputDir = true;
% make sure the input only load once (first one)
isLotalFieldLoad    = false;
isWeightLoad        = false;
isMagnLoad          = false; 
maskCSF             = [];

%% Check if output directory exists 
output_index = strfind(output, filesep);
outputDir = output(1:output_index(end));
% get prefix
if ~isempty(output(output_index(end)+1:end))
    prefix = [output(output_index(end)+1:end) '_'];
end
% if the output directory does not exist then create the directory
if exist(outputDir,'dir') ~= 7
    mkdir(outputDir);
end

%% Parse input argument
[~,isGPU,~,~,...
    ~,~,~,~,...
    ~,~,~,~,~,~,~,~,~,~,...
    QSM_method,QSM_threshold,QSM_lambda,QSM_optimise,QSM_tol,QSM_maxiter,...
    QSM_tol1,QSM_tol2,QSM_padsize,QSM_mu1,QSM_mu2,QSM_solver,QSM_constraint,...
    QSM_radius,QSM_zeropad,QSM_wData,QSM_wGradient,QSM_isLambdaCSF,QSM_lambdaCSF,...
    QSM_isSMV,QSM_merit] = parse_varargin_sepia(varargin);

%% Read input
disp('Reading data...');

% Step 1: check input for nifti files first
if isstruct(input)
    % Option 1: input are files
    inputNiftiList = input;
    isInputDir = false;
    
    % take the phase data directory as reference input directory 
    [inputDir,~,~] = fileparts(inputNiftiList(1).name);
else
    % Option 2: input is a directory
    inputDir = input;
    inputNiftiList = dir([inputDir '/*.nii*']);
end

% Step 2: load data
if ~isempty(inputNiftiList)
    
    if ~isInputDir
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%% Pathway 1: Input are NIfTI files %%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
                        %%%%%%%%%% Local field map %%%%%%%%%% 
        if ~isempty(inputNiftiList(1).name)
            inputLocalFieldNifti = load_untouch_nii([inputNiftiList(1).name]);
            localField = double(inputLocalFieldNifti.img);
            isLotalFieldLoad = true;
            
            disp('Local field map is loaded.')
        else
            error('Please specify a 3D local field map.');
        end
        
                        %%%%%%%%%% magnitude data %%%%%%%%%%
        if ~isempty(inputNiftiList(2).name)
            inputMagnNifti = load_untouch_nii([inputNiftiList(2).name]);
            % make sure the data is multi-echo magnitude data
            if size(inputMagnNifti.img,4) > 1
                magn = double(inputMagnNifti.img);
                isMagnLoad = true;
                disp('Magnitude data is loaded.');
            else
                error('QSM Hub only works with 4D data.');
            end
        else
            disp('No magnitude data is loaded.');
            magn = ones(size(localField));
        end
        
                        %%%%%%%%%% weights map %%%%%%%%%%
        if ~isempty(inputNiftiList(3).name)
            inputWeightNifti = load_untouch_nii([inputNiftiList(3).name]);
            weights = double(inputWeightNifti.img);
            % check whether phase data contains DICOM values or wrapped
            if size(weights,4) > 1
                error('Please specify a 3D weight data.');
            end
            isWeightLoad = true;
            disp('Weights data is loaded');
        else
            disp('Default weighting method will be used for QSM.');
        end
        
                        %%%%%%%%%% qsm hub header %%%%%%%%%%
        if ~isempty(inputNiftiList(4).name)
            load([inputNiftiList(4).name]);
            disp('Header data is loaded.');
        else
            error('Please specify a qsm_hub header.');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%% Pathway 2: Input is a directory with NIfTI %%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % loop all NIfTI files in the directory for magnitude,localField and fieldmapSD
        for klist = 1:length(inputNiftiList)

                        %%%%%%%%%% Local field map %%%%%%%%%%
            if ContainName(lower(inputNiftiList(klist).name),'local-field') && ~isLotalFieldLoad
                inputLocalFieldNifti = load_untouch_nii([inputDir filesep inputNiftiList(klist).name]);
                localField = double(inputLocalFieldNifti.img);
                isLotalFieldLoad = true;
                disp('Local field map is loaded.')
            end

                        %%%%%%%%%% magnitude data %%%%%%%%%%
            if ContainName(lower(inputNiftiList(klist).name),'magn') && ~ContainName(lower(inputNiftiList(klist).name),'brain') && ~isMagnLoad
                inputMagnNifti = load_untouch_nii([inputDir filesep inputNiftiList(klist).name]);
                isMagnLoad = true;
                magn = double(inputMagnNifti.img);
                disp('Magnitude data is loaded.')
            end

                        %%%%%%%%%% weights map %%%%%%%%%%
            if ContainName(lower(inputNiftiList(klist).name),'weights') && ~isWeightLoad
                inputWeightNifti = load_untouch_nii([inputDir filesep inputNiftiList(klist).name]);
                weights = double(inputWeightNifti.img);
                isWeightLoad = true;
                disp('Weights data is loaded.')
            end

        end

        % if no files matched the name format then displays error message
        if ~isLotalFieldLoad
            error('No local field map is loaded. Please make sure the input directory contains files with name *localfield*');
        end

                    %%%%%%%%%% qsm hub header file %%%%%%%%%%
        if ~isempty(dir([inputDir '/*header*']))
            % load header
            headerList = dir([inputDir '/*header*']);
            load([inputDir filesep headerList(1).name]);

            disp('Header data is loaded.');

        else
            disp('No header for qsm_hub is found. Creating synthetic header based on NIfTI header...');

            % create synthetic header in case no qsm_hub's header is found
            [B0,B0_dir,voxelSize,matrixSize,TE,delta_TE,CF]=SyntheticQSMHubHeader(inputLocalFieldNifti);

            % look for text file for TEs information
            teTextFullName = dir([inputDir filesep '*txt']);
            if ~isempty(teTextFullName)
                te_ = readTEfromText([inputDir filesep teTextFullName(1).name]);
                te_ = te_(:);
                if ~isempty(te_)
                    TE = te_;
                    if length(TE) > 1
                        delta_TE = TE(2)-TE(1);
                    end
                end
            end

            % if no header file then save the synthetic header in output dir
            save([outputDir filesep 'SyntheticQSMhub_header'],'voxelSize','matrixSize','CF','delta_TE',...
            'TE','B0_dir','B0');

            disp('The synthetic header is saved in output directory.');

        end

        % if no magnitude found then creates one with all voxels have the same value
        if ~isMagnLoad && strcmpi(QSM_method,'medi_l1')
            error('MEDI requires magnitude data. Please put the magnitude multi-echo data to input directory or use other algorithm');
        elseif ~isMagnLoad
            disp('No magnitude data is loaded.');
            magn = ones(matrixSize);
        end
    end
    
    % if no fieldmapSD found then creates one with all voxels have the same value
    if ~isWeightLoad
        disp('No weights file is loaded.');
%         fieldmapSD = ones(matrixSize) * 0.01;
        weights = ones(matrixSize);
    end
    
    % store the header the NIfTI files, all following results will have
    % the same header
    outputNiftiTemplate = inputLocalFieldNifti;
    
else
    error('This standalone only reads NIfTI format input data (*.nii or *.nii.gz).');
end

% display some header info
disp('Basic DICOM information');
disp(['Voxel size(x,y,z mm^3) =  ' num2str(voxelSize(1)) 'x' num2str(voxelSize(2)) 'x' num2str(voxelSize(3))]);
disp(['matrix size(x,y,z) =  ' num2str(matrixSize(1)) 'x' num2str(matrixSize(2)) 'x' num2str(matrixSize(3))]);
disp(['B0 direction(x,y,z) =  ' num2str(B0_dir(:)')]);
disp(['Field strength(T) =  ' num2str(B0)]);

%% get brain mask
% look for qsm mask first
maskList = dir([inputDir '/*mask-qsm*']);
% if no final mask then just look for normal mask
if isempty(maskList)
    maskList = dir([inputDir '/*mask*']);
end

if ~isempty(maskFullName)
    % Option 1: mask file is provided
    maskFinal = load_nii_img_only(maskFullName) > 0;
    
elseif ~isempty(maskList) 
    % Option 2: input directory contains NIfTI file with name '*mask*'
    inputMaskNii = load_untouch_nii([inputDir filesep maskList(1).name]);
	maskFinal = inputMaskNii.img > 0;
    
else
    % display error message if nothing is found
    error('No mask file is loaded. Pleasee specific your mask file or put it in the input directory.');
    
end

% create weighting map based on final mask
% for weighting map: higher SNR -> higher weighting
% wmap = fieldmapSD./norm(fieldmapSD(maskFinal==1));    
% wmap = 1./fieldmapSD;
% wmap(isinf(wmap)) = 0;
% wmap(isnan(wmap)) = 0;
% wmap = wmap./max(wmap(maskFinal>0));
weights = weights .* maskFinal;

%% qsm
disp('Computing QSM...');

% some QSM algorithms work better with certain unit of the local field map
switch lower(QSM_method)
    case 'closedforml2'
        
    case 'ilsqr'
        
    case 'stisuiteilsqr'
        % The order of local field values doesn't affect the result of chi  
        % in STI suite v3 implementation, i.e. 
        % chi = method(localField,...) = method(localField*C,...)/C, where
        % C is a constant.
        % Therefore, because of the scaling factor in their implementation,
        % the local field map is converted to rad
        localField = localField * 2*pi * delta_TE; 
        
    case 'fansi'
        % FANSI default parameters are optimised for ppm
        localField = localField/(B0*gyro);
        
    case 'ssvsharp'
        % not support yet
        
    case 'star'
        % Unlike the iLSQR implementation, the order of local field map
        % values will affect the Star-QSM result, i.e. 
        % chi = method(localField,...) ~= method(localField*C,...)/C, where
        % C is a constant. Lower order of local field magnitude will more 
        % likely produce chi map with streaking artefact. 
        % In the STI_Templates.m example, Star-QSM expecting local field in 
        % the unit of rad. However, value of the field map in rad will 
        % vary with echo time. Therefore, data acquired with short
        % delta_TE will be prone to streaking artefact. To mitigate this
        % potential problem, local field map is converted from Hz to radHz
        % here and the resulting chi will be normalised by the same factor 
        % 
        localField = localField * 2*pi;
        
    case 'medi_l1'
        % zero reference using CSF requires CSF mask
        if QSM_isLambdaCSF && isMagnLoad
            disp('Extracting CSF mask....');
            
            % R2* mapping
            r2s = arlo(TE,magn);
            maskCSF = extract_CSF(r2s,maskFinal,voxelSize)>0;
        end
        
        % MEDI input expects local field in rad
        localField = localField*2*pi*delta_TE;
end

% core of QSM
if isGPU
    chi = cuQSMMacro(localField,maskFinal,matrixSize,voxelSize,...
                     'method',QSM_method,'threshold',QSM_threshold,'lambda',QSM_lambda,...
                     'optimise',QSM_optimise,'tol',QSM_tol,'iteration',QSM_maxiter,'weight',weights,...
                     'b0dir',B0_dir,'tol_step1',QSM_tol1,'tol_step2',QSM_tol2,'TE',delta_TE,'B0',B0,...
                     'padsize',QSM_padsize,'mu',QSM_mu1,'mu2',QSM_mu2,QSM_solver,QSM_constraint,...
                     'noisestd',weights,'magnitude',sqrt(sum(magn.^2,4)),'data_weighting',QSM_wData,...
                     'gradient_weighting',QSM_wGradient,'merit',QSM_merit,'smv',QSM_isSMV,'zeropad',QSM_zeropad,...
                     'lambda_CSF',QSM_lambdaCSF,'CF',CF,'radius',QSM_radius,'Mask_CSF',maskCSF);
else
    chi = QSMMacro(localField,maskFinal,matrixSize,voxelSize,...
                   'method',QSM_method,'threshold',QSM_threshold,'lambda',QSM_lambda,...
                   'optimise',QSM_optimise,'tol',QSM_tol,'iteration',QSM_maxiter,'weight',weights,...
                   'b0dir',B0_dir,'tol_step1',QSM_tol1,'tol_step2',QSM_tol2,'TE',delta_TE,'B0',B0,...
                   'padsize',QSM_padsize,'mu',QSM_mu1,'mu2',QSM_mu2,QSM_solver,QSM_constraint,...
                   'noisestd',weights,'magnitude',sqrt(sum(magn.^2,4)),'data_weighting',QSM_wData,...
                   'gradient_weighting',QSM_wGradient,'merit',QSM_merit,'smv',QSM_isSMV,'zeropad',QSM_zeropad,...
                   'lambda_CSF',QSM_lambdaCSF,'CF',CF,'radius',QSM_radius,'Mask_CSF',maskCSF);
end

% convert the susceptibility map into ppm
switch lower(QSM_method)
    case 'tkd'
        chi = chi/(B0*gyro);
    case 'closedforml2'
        chi = chi/(B0*gyro);
    case 'ilsqr'
        chi = chi/(B0*gyro);
    case 'stisuiteilsqr'
        % STI suite v3 implementation already converted the chi map to ppm
    case 'fansi'
        % FANSI default parameters are optimised for ppm
    case 'ssvsharp'
        chi = chi/(B0*gyro);
    case 'star'
        % STI suite v3 implementation already nomalised the output by B0
        % and delta_TE, since the input is radHz here, we have to
        % multiply the reuslt by delta_TE here
        chi = chi * delta_TE;
    case 'medi_l1'
        % MEDI implementation already normalised the output to ppm
end

% save results
disp('Saving susceptibility map...');

save_nii_quick(outputNiftiTemplate, chi, [outputDir filesep prefix 'QSM.nii.gz']);

disp('Done!');

end
