class Event < ActiveRecord::Base
	belongs_to :user
	validates :user_id, presence: true
	validates :name, presence: true
	validates :description, presence: true
	validates :start_time, presence: true
	validates :end_time, presence: true
end