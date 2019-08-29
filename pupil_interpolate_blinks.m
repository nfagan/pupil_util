function out_trace = pupil_interpolate_blinks(pupil_trace, neg_peaks, pos_peaks, margin)

out_trace = pupil_trace;

for i = 1:numel(neg_peaks)  
  t2 = max( neg_peaks(i) - 1 - margin, 1 );
  t3 = min( pos_peaks(i) + 1 + margin, numel(pupil_trace) );
  
  t1 = clamp( t2 - t3 + t2, 1, numel(pupil_trace) );
  t4 = clamp( t3 - t2 + t3, 1, numel(pupil_trace) );
  ts = unique( [t1, t2, t3, t4] );
  
  y = pupil_trace(ts);
  xx = t1:t4;
  yy = spline( ts, y, xx );
  out_trace(xx) = yy;
end

end

function v = clamp(v, min, max)

if ( v < min )
  v = min;
elseif ( v > max )
  v = max;
end

end