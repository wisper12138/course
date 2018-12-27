class Activity < ActiveRecord::Base
    belongs_to :user
    validates :title, presence: true, length: {minimum: 5}
    validates :speaker, presence: true
    validates :class_room, presence: true
end