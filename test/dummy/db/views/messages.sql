-- Sample virtual model to test the gem.
-- output:
-- receiver_name, receiver_id, sender_name, sender_id, content, updated_at, created_at
SELECT DISTINCT _.receiver_name, _.receiver_id, _.sender_name, _.sender_id, _.content, _.updated_at, _.created_at
FROM #{puts "This is evaluated in Ruby."; ""}
  (SELECT u2.name as receiver_name, u2.id as receiver_id,
      u1.name as sender_name, u1.id as sender_id,
      um.content as content, um.updated_at as updated_at, um.created_at as created_at
    FROM users u1
    INNER JOIN user_messages um ON ( u1.id = um.from_id )
    INNER JOIN users u2 ON (u2.id = um.to_id)
  UNION
    SELECT u1.name as receiver_name, u1.id as receiver_id,
      u2.name as sender_name, u2.id as sender_id,
      um.content as content, um.updated_at as updated_at, um.created_at as created_at
    FROM users u1
    INNER JOIN user_messages um ON ( u1.id = um.to_id )
    INNER JOIN users u2 ON ( u2.id = um.from_id )
  ORDER BY created_at ASC
) AS _