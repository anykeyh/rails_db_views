(x integer, y integer) RETURNS integer AS $$
  BEGIN
    RETURN x + y;
  END;
$$ LANGUAGE plpgsql;