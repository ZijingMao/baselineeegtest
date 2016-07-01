function [enhancedResponse, DTarget, D] = mxDAWN(signal,index,verbose)
%% Warning: if this function is used then you must cite at least this paper:
% B. Rivet, A. Souloumiac, V. Attina, and G. Gibert, �xDAWN algorithm to enhance evoked potentials: application to brain-computer interface,�
% IEEE Trans Biomed Eng., vol. 56, no. 8, pp. 2035�43, 2009.
%
%% mxDAWN
% Function used to estimate the spatial filter that enhance signal :
% || signal - Sum_i(Di*Ai) || where Di are sparse Toeplitz.
%
% [synchronisedResponses, enhancedResponse] = mxDAWN(signal, index, targetStimulus) estimates
% the canonical directions associated with the canonical angles of spaces
% spanned by signal and toeplitz matrix whose first column non-zero 
% elements indexes are defined by vector 'index'.
%
% Inputs:
%	_ signal: matrix whose column are time-courses of signals
%	_ index: structure containing vectors defining the Di matrix
%	_ targetStimulus: index of the target stimulus which is enhanced.
%   _ verbose: Display or not some information (not to poluate the
%   command line)
%
% Output:
%	_ enhancedResponse: structure containing the spatial filters u, the
%	spatial distribution w of the enhanced synhronised response of the
%	target stimulus.
%
% Initial source code and method : Bertrand RIVET (2008)
% Changes: Hubert CECOTTI (2010)

targetStimulus=1;

if verbose==2
    fprintf(['\t_ Least squares estimation of the target kernel...']);
	tic; 
end

nbSample = size(signal,1);
nbStimuli = length(index);

% Memory allocation for stimuli matrix
if verbose==2
fprintf(['\t\t\t Memory allocation for stimuli matrix...\n']);
end

sumBlockLength = 0;
for indStimuli = 1:nbStimuli
	sumBlockLength = sumBlockLength + index(indStimuli).blockLength;
end
D = sparse(nbSample, double(ceil(sumBlockLength)));

% Computation of stimuli matrix (matrix D in the paper)
if verbose==2
fprintf(['\t\t\t Computation of stimuli matrix...\n']);
end

indexStart = 1;
for indStimuli = 1:nbStimuli
    % Inititialize the matrix nbSample * blockLength
    if verbose==2
        tic;
        fprintf(['\t\t\t\t indStimuli=' num2str(indStimuli) '\n']);
    end
	Dtmp = sparse(nbSample, double(index(indStimuli).blockLength));

	% Fill diagonals of 1
    for indEpoch = 1:index(indStimuli).blockLength
		Dtmp(index(indStimuli).indexStimulus+(indEpoch-1),indEpoch) = 1;
	end
	D(:,indexStart:indexStart+index(indStimuli).blockLength-1) = Dtmp;
	if targetStimulus == indStimuli
		DTarget = Dtmp; % D1 in the paper 
% 		indexStartTarget = indexStart;
	end
	indexStart = indexStart + index(indStimuli).blockLength;
    
    if verbose==2
        fprintf(['\t\t\t(' num2str(toc) 's) -> ok\n']);
    end
end
% clear indexStimuli ???

% Computation of synchronised response
% � = (D'*D)^-1 D' X
if verbose==2
fprintf(['\t\t\t Computation of synchronised response...\n']);
end
invDD = inv(D.' * D);
B = invDD * D.';

clear Dtmp invDD

indexStart = 1;
for indStimuli = 1:nbStimuli
    if verbose==2
        tic;
        fprintf(['\t\t\t\t indStimuli=' num2str(indStimuli) '\n']);
    end
    % computation of Achapeau
	synchronisedResponses(indStimuli).kernelLeastSquare = ...
		B(indexStart:indexStart+index(indStimuli).blockLength-1,:) * signal;
	
	if targetStimulus == indStimuli
		BTarget = B(indexStart:indexStart+index(indStimuli).blockLength-1,:);
	end
	
	indexStart = indexStart + index(indStimuli).blockLength;
    if verbose==2
        fprintf(['\t\t\t(' num2str(toc) 's) -> ok\n']);
    end
end
% BTarget = B(indexStartTarget:indexStartTarget+index(indStimuli).blockLength-1,:);
clear B 

% Computation of enhanced response
if verbose==2
fprintf(['\t\t\t Computation of enhanced response...\n']);
end
	% 1. QR of X
	[Qx,Rx] = qr(signal,0);
	clear signal

	% 2. QR of D1
	Rd1 = qr(DTarget,0);

	% 3. SVD of Q.' * Qx
	L = BTarget * Qx;
	clear Qx
	[U, S, V] = svd(Rd1 * L, 0);
    % In the paper U=phi S=lambda V=psi

	% 4. Result
	enhancedResponse.spatialFilter = inv(Rx) * V; % le � dans l article
	enhancedResponse.kernel = inv(Rd1) * U * S; % le �1
	enhancedResponse.spatialDistribution = Rx.' * V;
	enhancedResponse.singularValue = diag(S);
    enhancedResponse.SSNR=diag(S'*S); % without the normalization
    
    SD=enhancedResponse.spatialDistribution;
    SD=SD(:,1);
    SD=SD/sum(SD);
    enhanceResponse.spatialDistribution2plot=SD;
      
if verbose==2
    fprintf(['\t\t\t xDAWN done.\n']);
end

if verbose==2
    fprintf(['(' num2str(toc) 's) -> ok\n']);
end


