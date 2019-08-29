function [psth, psth_t] = pupil_psth(events, pupil, t, min_t, max_t)

sample_span = ceil( max_t - min_t );

psth = nan( numel(events), sample_span );
psth_t = (0:sample_span-1) + min_t;

for i = 1:numel(events)
  use_span = sample_span;
  event = events(i) + min_t;
  
  min_ind = find( t == event );
  offset = 0;

  if ( isempty(min_ind) )
    min_ind = find( t >= event, 1 );
    offset = t(min_ind) - event;
    use_span = sample_span - offset;
  end
  
  if ( numel(min_ind) ~= 1 )
    error( 'Expected one time point match for %d; got %d.' ...
      , events(i), numel(min_ind) );
  end
  
  max_ind = min( numel(pupil), min_ind + use_span - 1 );
  assign_ind = (1:use_span) + offset;
  
  subset_pupil = pupil(min_ind:max_ind);
  
  psth(i, assign_ind) = subset_pupil;
end

end