function in = pupil_extract_initials(str)

in = str(isstrprop(str, 'alpha') & isstrprop(str, 'upper'));

end