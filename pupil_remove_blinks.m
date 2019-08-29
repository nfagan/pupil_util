function out_trace = pupil_remove_blinks(pupil_trace, vel_thresh, margin, max_blink_dur)

% https://www.researchgate.net/post/Is_there_a_standard_approach_for_cleaning_and_analysing_pupil_dilation_data

[neg_peaks, pos_peaks] = pupil_find_blinks( pupil_trace, vel_thresh, max_blink_dur );
out_trace = pupil_interpolate_blinks( pupil_trace, neg_peaks, pos_peaks, margin );

end