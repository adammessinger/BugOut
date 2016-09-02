class Bug < ActiveRecord::Base
  belongs_to :reporter, class_name: :User, foreign_key: :reporter_id, inverse_of: :reports
  belongs_to :assignee, class_name: :User, foreign_key: :assignee_id, inverse_of: :assignments
  has_many :comments, dependent: :destroy

  validates(:title, presence: true)
  validates(:title, length: { in: 10..255 })
  validates(:title, uniqueness: { case_sensitive: false })
  validates(:reporter_id, presence: true)
  validates(:reporter, presence: true)
  validates(:assignee, presence: true, if: 'assignee_id.present?')
  validates(:description, presence: true)
  validates(:description, length: { in: 24..65_000 })
  validates(:description, uniqueness: { case_sensitive: false })

  def owned_by?(user = nil)
    return nil unless user.is_a?(User)
    user == reporter || user == assignee
  end

  def assignee_or_comments?
    comments.any? || assignee.present?
  end
end
