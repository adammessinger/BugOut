class Bug < ActiveRecord::Base
  belongs_to :reporter, class_name: :User, foreign_key: :reporter_id, validate: true
  belongs_to :assignee, class_name: :User, foreign_key: :assignee_id, validate: true
  has_many :comments, dependent: :destroy

  validates(:title, presence: true)
  validates(:reporter_id, presence: true)
  validates(:description, presence: true)

  def owned_by?(user = nil)
    return nil unless user.is_a?(User)
    user == reporter || user == assignee
  end
end
