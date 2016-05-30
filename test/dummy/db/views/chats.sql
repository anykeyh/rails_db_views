# This is the request for virtual chat object.
# !require messages
SELECT #{"tuple_sort"}(ARRAY[sender_id, receiver_id]) AS ids,
  MIN(created_at) as created_at, MAX(updated_at) as updated_at, COUNT(*) as number_of_messages
FROM messages
GROUP BY tuple_sort(ARRAY[sender_id, receiver_id])
