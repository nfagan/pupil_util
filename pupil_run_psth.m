function [psths, t, ids] = pupil_run_psth(outs, varargin)

defaults = struct();
defaults.normalize = true;
defaults.min_t = 0;
defaults.max_t = 12e3;
defaults.base_min_t = 0;
defaults.base_max_t = 2e3;

params = shared_utils.general.parsestruct( defaults, varargin );

min_t = params.min_t;
max_t = params.max_t;

base_min_t = params.base_min_t;
base_max_t = params.base_max_t;

do_normalize = params.normalize;

psths = cell( size(outs.samples) );
ids = cell( size(outs.samples) );

for i = 1:numel(outs.samples)
  start_times = outs.events{i, 1};
  samples = outs.samples{i};
  
  [psths{i}, t] = pupil_psth( start_times, samples.pupilSize, samples.time, min_t, max_t );
  
  if ( do_normalize )
    base_psth = pupil_psth( start_times, samples.pupilSize, samples.time, base_min_t, base_max_t );
    base_psth = mean( base_psth, 2 );
    
    psths{i} = bsxfun( @rdivide, psths{i}, base_psth );
  end
  
  ids{i} = [ repmat(outs.block_ids(i), numel(start_times), 1), (1:numel(start_times))' ];
end

psths = vertcat( psths{:} );
ids = vertcat( ids{:} );

end