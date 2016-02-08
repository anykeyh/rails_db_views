(x int[]) RETURNS int[] AS $$
  BEGIN
    -- Note to myself: selection in array start at 1, not at zero !
    IF x[1]::int > x[2]::int THEN
      RETURN ARRAY[x[2], x[1]];
    ELSE
      RETURN x;
    END IF;
  END;
$$ LANGUAGE plpgsql;