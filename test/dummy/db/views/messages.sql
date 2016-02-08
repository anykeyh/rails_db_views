-- Sample virtual model to test the gem.

SELECT u2.name as receiver_name, u2.id as receiver_id,
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
ORDER BY um.created_at ASC