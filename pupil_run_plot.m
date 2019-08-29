%%

do_remove_blinks = false;
outs = pupil_load_data( '/Users/Nick/Desktop/pupil/data', do_remove_blinks );

%%

[psth, t, ids] = pupil_run_psth( outs ...
  , 'normalize', false ...
  , 'min_t', 0 ...
  , 'max_t', 12e3 ...
);

psth = rowwise( psth, @(x) smoothdata(x, 'smoothingfactor', 0.2) );
sans_blinks = rowwise( psth, @(x) pupil_remove_blinks(x, 0.6, 20, 1000) );

labels = vertcat( outs.labels{:} );

%%

out_trace = pupil_mark_blinks( psth(1, :), 20 );

%%

stp = 18;

while ( stp <= rows(psth) )
  hold off;
  plot( psth(stp, :) );
  hold on;
  plot( sans_blinks(stp, :), 'linewidth', 2  );
  
  input( sprintf('%d', stp) );
  stp = stp + 1;
end

%%

save_p = fullfile( '~/Desktop/pupil/plots/per_trial_traces/0_12s' );
do_save = true;

pl = plotlabeled.make_common();
fig = figure(1);

for i = 1:size(psth, 1)
  labs = fcat.from( labels(i, :), outs.categories );
  
  pl = plotlabeled.make_common();
  pl.add_smoothing = true;
  pl.x = t;
  axs = pl.lines( psth(i, :), labs, {}, getcats(labs) );
  
  if ( do_save )
    shared_utils.plot.fullscreen( fig );
    dsp3.req_savefig( fig, save_p, labs, getcats(labs) );
  end
end