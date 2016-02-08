class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true


  has_many :sended_messages, class_name: "UserMessage", foreign_key: :from
  has_many :received_messages, class_name: "UserMessage", foreign_key: :to

  has_many :messages

  def message! user, content
    UserMessage.create! from: self, to: user, content: content
  end

  # Return all chats of this guy!
  def chats
    Chat.where("'{?}' && ids", self.id)
  end
end