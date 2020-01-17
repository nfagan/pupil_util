function [binned, t] = pupil_bin_processed_data(traces, bin_size, step_size)

if ( nargin < 3 )
  step_size = bin_size;
end

t_ind = 1:size(traces, 2);
bin_inds = shared_utils.vector.slidebin( t_ind, bin_size, step_size );

binned = cellfun( @(x) nanmean(traces(:, x), 2), bin_inds, 'un', 0 );
binned = horzcat( binned{:} );

t = cellfun( @(x) x(1)-1, bin_inds );

end