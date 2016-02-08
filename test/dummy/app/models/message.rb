class Message < ActiveRecord::Base
  #receiver_name, receiver_id, sender_name, sender_id, content, updated_at, created_at
  belongs_to :receiver, class_name: "User"
  belongs_to :sender, class_name: "Sender"

end