function pupil_plot_subject_data_lines(pupil_outs, varargin)

defaults = pupil_get_common_plot_defaults();
defaults.plot_funcs = all_plot_funcs();
defaults.task_type = pupil_task_type( 'original' );
defaults.per_trial_number = false;

params = shared_utils.general.parsestruct( defaults, varargin );
plot_funcs = cellstr( params.plot_funcs );
task_type = pupil_task_type( params.task_type );

for i = 1:numel(plot_funcs)
  feval( plot_funcs{i}, pupil_outs, task_type, params );
end

end

function plot_conditions_across_subjects(pupil_outs, task_type, params)

fig_cats = {};
gcats = { 'touch-type', 'hand-type' };
pcats = {};

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  pcats{end+1} = 'condition';
end

if ( params.per_trial_number )
  gcats{end+1} = 'trial';
end

subdirs = { 'per_condition_across_subjects' };

plot_lines( pupil_outs, fig_cats, gcats, pcats, params, subdirs );

end

function plot_conditions_per_subject(pupil_outs, task_type, params)

fig_cats = { 'subject' };
gcats = { 'touch-type', 'condition' };
pcats = { 'block', 'subject' };

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  gcats{end+1} = 'hand-type';
end

if ( params.per_trial_number )
  gcats{end+1} = 'trial';
end

subdirs = { 'per_condition_per_subject' };

plot_lines( pupil_outs, fig_cats, gcats, pcats, params, subdirs );

end

function plot_each_trial_per_subject(pupil_outs, task_type, params)

fig_cats = { 'subject' };
gcats = { 'touch-type', 'condition', 'trial' };
pcats = { 'block', 'subject' };

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  gcats{end+1} = 'hand-type';
end

subdirs = { 'per_subject_per_trial' };

plot_lines( pupil_outs, fig_cats, gcats, pcats, params, subdirs );

end

function plot_lines(pupil_outs, fig_cats, gcats, pcats, params, subdirs)

mask = params.mask_func( pupil_outs.labels );

fig_I = findall_or_one( pupil_outs.labels, fig_cats, mask );

for i = 1:numel(fig_I)
  shared_utils.general.progress( i, numel(fig_I) );
  
  subset_traces = pupil_outs.traces(fig_I{i}, :);
  subset_labels = prune( pupil_outs.labels(fig_I{i}) );

  pl = plotlabeled.make_common();
  pl.per_panel_labels = true;
  pl.one_legend = false;
  pl.add_errors = false;
  pl.color_func = @hsv;

  [axs, hs, inds] = pl.lines( subset_traces, subset_labels, gcats, pcats );
  
  if ( params.save )
    shared_utils.plot.fullscreen( gcf() );
    save_dir = fullfile( params.save_dir, subdirs{:} );
    dsp3.req_savefig( gcf(), save_dir, subset_labels, [gcats, pcats, fig_cats], params.prefix );
  end
end

end

function funcs = all_plot_funcs()

funcs = { 'plot_conditions_per_subject', 'plot_each_trial_per_subject' ...
  , 'plot_conditions_across_subjects' };

end