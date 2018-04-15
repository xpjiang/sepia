fullName = mfilename('fullpath');

currDir = fileparts(fullName);

bkgRemovalFOLDER = [currDir filesep 'background_removal/'];
addpath(bkgRemovalFOLDER);
addpath([bkgRemovalFOLDER 'iHARPERELLA' filesep 'STISuitev2_2']);
addpath([bkgRemovalFOLDER 'LBV' filesep 'MEDI_20171106']);
addpath([bkgRemovalFOLDER 'PDF' filesep 'MEDI_20171106']);
addpath([bkgRemovalFOLDER 'SHARP']);
addpath([bkgRemovalFOLDER 'VSHARP' filesep 'vsharp_chan']);
% addpath([bkgRemovalFOLDER 'VSHARP' filesep 'STISuitev2_2']);
addpath([bkgRemovalFOLDER 'VSHARP' filesep 'STISuitev3']);
addpath([bkgRemovalFOLDER 'RESHARP']);
addpath([bkgRemovalFOLDER 'utils']);

phaseUnwrapFOLDER = [currDir filesep 'phase_unwrap/'];
addpath(phaseUnwrapFOLDER);
addpath([phaseUnwrapFOLDER 'unwrapGraphcut']);
addpath([phaseUnwrapFOLDER 'unwrapJena']);
addpath([phaseUnwrapFOLDER 'unwrapLaplacian']);
addpath([phaseUnwrapFOLDER 'unwrapRegionGrowing']);

qsmAlgorithmFOLDER = [currDir filesep 'qsm_algorithm/'];
addpath(qsmAlgorithmFOLDER);
addpath([qsmAlgorithmFOLDER 'closedFormL2']);
addpath([qsmAlgorithmFOLDER 'iLSQR']);
addpath([qsmAlgorithmFOLDER 'iLSQR' filesep 'iLSQR_chan']);
addpath([qsmAlgorithmFOLDER 'iLSQR' filesep 'STISuitev3']);
addpath([qsmAlgorithmFOLDER 'TKD']);
addpath([qsmAlgorithmFOLDER 'FANSI']);
addpath([qsmAlgorithmFOLDER 'SingleStep']);
addpath([qsmAlgorithmFOLDER 'Star']);
addpath([qsmAlgorithmFOLDER 'utils']);
addpath(genpath([qsmAlgorithmFOLDER 'utils' filesep 'STISuitev3']));

utilsFOLDER = [currDir filesep 'utils/'];
addpath(utilsFOLDER);
addpath([utilsFOLDER 'nifti/NIfTI_20140122/']);
addpath([utilsFOLDER 'nifti/utils/']);
addpath([utilsFOLDER 'ReadDICOMMEDI/']);