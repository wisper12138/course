#sgg7
class Evaluation < ActiveRecord::Base
	belongs_to :course
	belongs_to :user
	#nskk4
	belongs_to :evaluationitem
end
