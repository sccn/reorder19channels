% reorder19Channels()--Re-orders the 19 channels defined by international 10-20 system 
%                      into a template order. It checks consistency between
%                      the template and the input channel labels. It is NOT
%                      case sensitive (i.e., inconsistency between FP1 and
%                      Fp1 does not matter). Both the new nomemclature (T7, T8,
%                      P7, P8) and the old nomenclature (T3, T4, T5, T6)
%                      are supported. When more than 19 channels were
%                      detected, discard all of the channels that are not
%                      included in the list.
%
% Usage: EEG = reorder19Channels(EEG)

% Copyright (C) 2017 Makoto Miakoshi. SCCN, INC, UCSD. mmiyakoshi@ucsd.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% 01/12/2024 Makoto. WinEEG's default channel labels with '-LE' is supported for automatic renaming. 
% 10/17/2017 Makoto. Created. 

function EEG = reorder19Channels(EEG)

% Abort if no channel label information present.
channelLabels = {EEG.chanlocs.labels};
if isempty(channelLabels)
    error('No channel labels available. Aborted.')
end

% Remove '-LE' from channel labels if present.
if sum(contains(channelLabels, '-LE'))==EEG.nbchan
    disp('The suffix ''-LE'' is detected in all channel labels. Removing them.')

    % Obtain the full path to standard_1005.elc
    try
        eeglabPath = which('eeglab');
        [eeglabRoot, name,ext] = fileparts(eeglabPath);
        standard_1005Path = [eeglabRoot filesep 'plugins' filesep 'dipfit' filesep 'standard_BEM' filesep 'elec' filesep 'standard_1005.elc'];

        % Remove '-LE'.
        for m = 1:length(EEG.chanlocs)
            EEG.chanlocs(m).labels = EEG.chanlocs(m).labels(1:end-3);
        end

        % Find template electrode locations.
        EEG = pop_chanedit(EEG, 'lookup', standard_1005Path);
        disp('Renaming the channel labels and finding their template locations successfully.')

    catch
        error('Automatic removal of ''-LE'' from channel labels failed. Please manually remove ''-LF'' from all channel labels and run ''look up locks''')
    end
end


% Define the template channel order.
templateChannelOrderOldNomenclature = {...
    'Fp1'...
    'Fp2'...
    'F7'...
    'F3'...
    'Fz'...
    'F4'...
    'F8'...
    'T3'...
    'C3'...
    'Cz'...
    'C4'...
    'T4'...
    'T5'...
    'P3'...
    'Pz'...
    'P4'...
    'T6'...
    'O1'...
    'O2'...
    };

templateChannelOrderNewNomenclature = {...
    'Fp1'...
    'Fp2'...
    'F7'...
    'F3'...
    'Fz'...
    'F4'...
    'F8'...
    'T7'...
    'C3'...
    'Cz'...
    'C4'...
    'T8'...
    'P7'...
    'P3'...
    'Pz'...
    'P4'...
    'P8'...
    'O1'...
    'O2'...
    };

% Obtain the current channel labels.
allChanelLabels = {EEG.chanlocs.labels};

% Check the consistency.
uniqueTmplateChannelsOldNomemclature = unique(templateChannelOrderOldNomenclature);
uniqueTmplateChannelsNewNomemclature = unique(templateChannelOrderNewNomenclature);
uniqueAllChanelLabels = unique(allChanelLabels);
if     sum(ismember(lower(uniqueTmplateChannelsOldNomemclature), lower(uniqueAllChanelLabels))) == length(templateChannelOrderOldNomenclature)
    disp('All 19-channel labels are present (old nomenclature detected). Re-ordering them now.')
    templateChannelOrder = templateChannelOrderOldNomenclature;
elseif sum(ismember(lower(uniqueTmplateChannelsNewNomemclature), lower(uniqueAllChanelLabels))) == length(templateChannelOrderNewNomenclature)
    disp('All 19-channel labels are present (new nomenclature detected). Re-ordering them now.')
    templateChannelOrder = templateChannelOrderNewNomenclature;
else
    error('Does not match to 19-channel labels. Aborting.')
end
    
% Obtain the reordering index.
[~,reorderingIdx] = ismember(lower(templateChannelOrder), lower(allChanelLabels));

% Reorder the channels.
EEG.chanlocs = EEG.chanlocs(reorderingIdx);
EEG.data     = EEG.data(reorderingIdx,:,:);

% Run the checkset.
EEG = eeg_checkset(EEG);

% Output eegh.
com = sprintf('EEG = reorder19Channels(EEG);');
EEG = eegh(com, EEG);

% Report it is done.
disp(sprintf('\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'))
disp(sprintf('The pre-defined 19 channels were selected and reordered to the template.'))
disp(sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'))
