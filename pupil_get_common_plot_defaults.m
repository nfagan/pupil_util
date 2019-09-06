function defaults = pupil_get_common_plot_defaults()

defaults.save_dir = '';
defaults.save = true;
defaults.prefix = '';
defaults.mask_func = @(labels) rowmask(labels);

end