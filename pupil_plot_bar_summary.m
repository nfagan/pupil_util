function pupil_plot_bar_summary(pupil_outs, varargin)

defaults = pupil_get_common_plot_defaults();
defaults.normalize = true;
defaults.base_t = [0, 2e3];
defaults.target_t = [2e3, 12e3];
defaults.task_type = pupil_task_type( 'original' );

params = shared_utils.general.parsestruct( defaults, varargin );
task_type = pupil_task_type( params.task_type );

target_pupil = get_target_pupil( pupil_outs, params );

plot_per_block_per_condition( target_pupil, pupil_outs.labels, task_type, params );

end

function plot_per_block_per_condition(pupil, labels, task_type, params)

fig_cats = {};

xcats = { 'condition' };
gcats = { 'touch-type' };
pcats = { 'block' };

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  xcats{end+1} = 'hand-type';
end

subdirs = { 'per_condition_across_subjects' };

plot_bars( pupil, labels, fig_cats, xcats, gcats, pcats, task_type, params, subdirs );

end

function target_pupil = get_target_pupil(pupil_outs, params)

target_pupil = average_time( pupil_outs.traces, pupil_outs.t, params.target_t );

if ( params.normalize )
  base_pupil = average_time( pupil_outs.traces, pupil_outs.t, params.base_t );
  target_pupil = target_pupil ./ base_pupil;
end

end

function pupil = average_time(pupil, t, t_window)

pupil = nanmean( pupil(:, t >= t_window(1) & t <= t_window(2)), 2 );

end

function plot_bars(pupil_data, pupil_labels, fig_cats, xcats, gcats, pcats, task_type, params, subdirs)

mask = params.mask_func( pupil_labels );
fig_I = findall_or_one( pupil_labels, fig_cats, mask );

for i = 1:numel(fig_I)
  shared_utils.general.progress( i, numel(fig_I) );
  
  pl = plotlabeled.make_common();
  pl.per_panel_labels = strcmp( task_type, pupil_task_type('original') );
  
  subset = pupil_data(fig_I{i});
  subset_labels = prune( pupil_labels(fig_I{i}) );
  
  axs = pl.bar( subset, subset_labels, xcats, gcats, pcats );
  
  if ( params.save )
    shared_utils.plot.fullscreen( gcf() );
    save_dir = fullfile( params.save_dir, subdirs{:} );
    dsp3.req_savefig( gcf(), save_dir, subset_labels, [gcats, pcats, fig_cats], params.prefix );
  end
end

end