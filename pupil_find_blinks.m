function [use_neg, use_pos] = pupil_find_blinks(pupil_trace, vel_thresh, max_blink_dur)

vel = gradient( pupil_trace );
vel = vel / max( vel(:) );

neg_peaks = shared_utils.logical.find_islands( vel < -vel_thresh );

[pos_starts, pos_durs] = shared_utils.logical.find_islands( vel > vel_thresh );
pos_peaks = pos_starts + pos_durs - 1;

use_neg = [];
use_pos = [];
offset = 0;

for i = 1:numel(neg_peaks)
  neg_peak = neg_peaks(i-offset);
  nearest_pos = find( pos_peaks > neg_peak, 1 );
  
  if ( ~isempty(nearest_pos) )
    tmp_pos_peak = pos_peaks(nearest_pos);
    blink_dur = tmp_pos_peak - neg_peak;
    
    if ( blink_dur > 0 && blink_dur < max_blink_dur )
      use_neg(end+1) = neg_peak;
      use_pos(end+1) = pos_peaks(nearest_pos);
    end
    
    pos_peaks(nearest_pos) = [];
    neg_peaks(i-offset) = [];
    
    offset = offset + 1;
  end
end

end