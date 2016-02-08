(x int[]) RETURNS int[] AS $$
  BEGIN
    IF x[0] > x[1] THEN
      RETURN ARRAY[x[1], x[0]];
    ELSE
      RETURN x;
    END IF;
  END;
$$ LANGUAGE plpgsql;