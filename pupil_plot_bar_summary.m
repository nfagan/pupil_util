function pupil_plot_bar_summary(pupil_outs, varargin)

defaults = pupil_get_common_plot_defaults();
defaults.normalize = true;
defaults.base_t = [0, 2e3];
defaults.target_t = [2e3, 12e3];
defaults.task_type = pupil_task_type( 'original' );
defaults.per_trial_number = false;
defaults.per_panel_labels = false;

params = shared_utils.general.parsestruct( defaults, varargin );
task_type = pupil_task_type( params.task_type );

target_pupil = get_target_pupil( pupil_outs, params );

plot_per_condition( target_pupil, pupil_outs.labels', task_type, params );
% plot_per_block_per_condition( target_pupil, pupil_outs.labels', task_type, params );

end

function plot_per_condition(pupil, labels, task_type, params)

fig_cats = {};

xcats = {};
gcats = { 'touch-type' };
pcats = { 'condition' };

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  xcats{end+1} = 'hand-type';
end

if ( params.per_trial_number )
  xcats{end+1} = 'trial';
end

subdirs = { 'per_condition_across_subjects' };

if ( params.per_panel_labels )
  gcats = union( gcats, xcats );
  plot_per_panel_bars( pupil, labels, fig_cats, gcats, pcats, task_type, params, subdirs );

else
  plot_bars( pupil, labels, fig_cats, xcats, gcats, pcats, task_type, params, subdirs );
end

end

function plot_per_block_per_condition(pupil, labels, task_type, params)

fig_cats = {};

xcats = { 'condition' };
gcats = { 'touch-type' };
pcats = { 'block' };

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  xcats{end+1} = 'hand-type';
end

if ( params.per_trial_number )
  xcats{end+1} = 'trial';
end

subdirs = { 'per_condition_across_subjects' };

if ( params.per_panel_labels )
  gcats = union( gcats, xcats );
  plot_per_panel_bars( pupil, labels, fig_cats, gcats, pcats, task_type, params, subdirs );

else
  plot_bars( pupil, labels, fig_cats, xcats, gcats, pcats, task_type, params, subdirs );
end

end

function target_pupil = get_target_pupil(pupil_outs, params)

target_pupil = average_time( pupil_outs.traces, pupil_outs.t, params.target_t );

if ( params.normalize )
  base_pupil = average_time( pupil_outs.traces, pupil_outs.t, params.base_t );
  target_pupil = target_pupil ./ base_pupil;
  target_pupil(~isfinite(target_pupil)) = nan;
end

end

function pupil = average_time(pupil, t, t_window)

pupil = nanmean( pupil(:, t >= t_window(1) & t <= t_window(2)), 2 );

end

function plot_per_panel_bars(pupil_data, pupil_labels, fig_cats, gcats, pcats, task_type, params, subdirs)

mask = params.mask_func( pupil_labels );
fig_I = findall_or_one( pupil_labels, fig_cats, mask );

close( gcf );

for i = 1:numel(fig_I)
  shared_utils.general.progress( i, numel(fig_I) );

  subset_labels = prune( pupil_labels(fig_I{i}) );

  [p_I, p_C] = findall( pupil_labels, pcats, fig_I{i} );
  axs = gobjects( size(p_I) );
  plot_shape = plotlabeled.get_subplot_shape( numel(p_I) );

  for j = 1:numel(p_I)
    axs(j) = subplot( plot_shape(1), plot_shape(2), j );
    cla( axs(j) );
    
    [g_I, g_C] = findall( pupil_labels, gcats, p_I{j} );
    g_labels = fcat.strjoin( g_C, ' | ' );

    means = cellfun( @(x) nanmean(pupil_data(x)), g_I );
    errs = cellfun( @(x) plotlabeled.nansem(pupil_data(x)), g_I );

    h = bar( axs(j), [means'; means'] );
    
    offs = zeros( size(means) );
    for k = 1:numel(means)
      offs(k) = h(k).XOffset;
    end
    
    center = arrayfun( @(x) min(x.XData), h );
    
    hold( axs(j), 'on' );
    legend( h, g_labels );
    xlim( axs(j), [0, 1.5] );
    
    pos = center + offs;
    y0 = means(:) - errs(:) * 0.5;
    y1 = means(:) + errs(:) * 0.5;
    
    line_hs = gobjects( size(y0) );
    
    for k = 1:numel(y0)
      line_hs(k) = plot( axs(j), [pos(k), pos(k)], [y0(k), y1(k)] );
      line_hs(k).Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    set( line_hs, 'linewidth', 1.5 );
    set( line_hs, 'color', zeros(1, 3) );

    title_str = strjoin( p_C(:, j), ' | ' );
    title( axs(j), title_str );
  end

  shared_utils.plot.match_ylims( axs );
  
  if ( params.save )
    shared_utils.plot.fullscreen( gcf() );
    save_dir = fullfile( params.save_dir, subdirs{:} );
    dsp3.req_savefig( gcf(), save_dir, subset_labels ...
      , [gcats, pcats, fig_cats], params.prefix );
  end
end

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