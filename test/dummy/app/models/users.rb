class User < ActiveRecord::Base
  validate :name, presence: true, uniqueness: true


  has_many :sended_messages, class_name: "UserMessage", foreign_key: :from
  has_many :received_messages, class_name: "UserMessage", foreign_key: :to

  has_many :messages
end