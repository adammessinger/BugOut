class User < ActiveRecord::Base
  has_many :reports, class_name: :Bug, foreign_key: :reporter_id, dependent: :nullify, inverse_of: :reporter
  has_many :assignments, class_name: :Bug, foreign_key: :assignee_id, dependent: :nullify, inverse_of: :assignee
  has_many :comments, foreign_key: :author_id, dependent: :nullify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable

  def to_s
    name
  end
end
