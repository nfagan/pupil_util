function ids = pupil_location_to_condition_id(locations)

if ( ischar(locations) )
  locations = { locations };
end

ids = cellfun( @to_id, locations );

end

function id = to_id(label)

switch ( lower(label) )
  case 'hand'
    id = 1;
  case 'arm'
    id = 2;
  case 'shoulder'
    id = 3;
  case 'neck'
    id = 4;
  otherwise
    error( 'Unrecognized location label "%s".', label );
end 

end