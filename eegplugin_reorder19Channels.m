% reorder19Channels()--Re-orders the 19 channels defined by international 10-20 system 
%                      into a template order. 

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

% 10/16/2017 Makoto. Created. 

function eegplugin_reorder19Channels(fig,try_strings,catch_strings)


% create menu
editMenuHandle = findobj(fig, 'label', 'Edit');
uimenu( editMenuHandle, 'label', 'Re-order 19 channels', 'separator', 'on', 'callback', 'EEG = reorder19Channels(EEG); eeglab redraw');