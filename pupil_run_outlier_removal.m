%%

% Dependencies: shared_utils, categorical

pupil_root = '/Users/olgadalmonte/Desktop/pupil';
subject_dir = 'SamanthaS_24052019';

outs = pupil_load_data( fullfile(pupil_root, 'raw', subject_dir) );

%%

normalize = false;
use_auto_blink_pass = false;

[psth, t, ids] = pupil_run_psth( outs ...
  , 'normalize', normalize ...
  , 'min_t', 0 ...
  , 'max_t', 12e3 ...
  , 'base_min_t', 0 ...
  , 'base_max_t', 200 ...
);

psth = rowwise( psth, @(x) smoothdata(x, 'smoothingfactor', 0.2) );

if ( use_auto_blink_pass )
  psth = rowwise( psth, @(x) pupil_remove_blinks(x, 0.6, 20, 1000) );
end

labels = vertcat( outs.labels{:} );
categories = outs.categories;

%%

do_save = true;
save_p = fullfile( pupil_root, 'processed', subject_dir );
shared_utils.io.require_dir( save_p );
start = 1;

margin = 20;  % Number of samples to look pre + post detected blink.

maximum = size( psth, 1 );
out_traces = nan( size(psth) );

while ( start <= maximum )
  response = input( sprintf('Proceed (%d of %d)? [Y]/n', start, maximum), 's' );
  
  if ( ~isempty(strfind(lower(response), 'n')) )
    break;
  end
  
  title( gca, sprintf('%d of %d', start, maximum) );
  
  out_trace = pupil_mark_blinks( psth(start, :), margin );
  
  start = start + 1;
  out_traces(start, :) = out_trace;
end

if ( do_save )
  save( fullfile(save_p, 'outlier_removed_traces.mat') ...
    , 'out_traces', 'psth', 'outs', 'labels', 'categories' );
end