%%

% Dependencies: shared_utils, categorical

pupil_root = '/Users/Nick/Desktop/pupil';

outs = pupil_load_data( fullfile(pupil_root, 'data') );

%%

use_auto_blink_pass = false;

[psth, t, ids] = pupil_run_psth( outs ...
  , 'normalize', false ...
  , 'min_t', 0 ...
  , 'max_t', 12e3 ...
);

psth = rowwise( psth, @(x) smoothdata(x, 'smoothingfactor', 0.2) );

if ( use_auto_blink_pass )
  psth = rowwise( psth, @(x) pupil_remove_blinks(x, 0.6, 20, 1000) );
end

labels = vertcat( outs.labels{:} );

%%

do_save = false;
save_p = fullfile( pupil_root, 'processed' );
shared_utils.io.require_dir( save_p );

start = 1;
margin = 20;

maximum = size( psth, 1 );
out_traces = nan( size(psth) );

while ( start < maximum )
  out_trace = pupil_mark_blinks( psth(start, :), margin );
  input( 'Press any key to continue.' );
  start = start + 1;
  out_trace(start, :) = out_trace;
end

if ( do_save )
  save( fullfile(save_p, 'outlier_removed_traces.mat'), 'out_traces' );
end