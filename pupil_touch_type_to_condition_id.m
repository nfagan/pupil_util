function ids = pupil_touch_type_to_condition_id(touch_types)

if ( ischar(touch_types) )
  touch_types = { touch_types };
end

ids = cellfun( @to_id, touch_types );

end

function id = to_id(label)

switch ( lower(label) )
  case 'control'
    id = 0;
  case 'social'
    id = 1;
  otherwise
    error( 'Unrecognized location label "%s".', label );
end 

end