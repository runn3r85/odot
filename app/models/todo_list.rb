class TodoList < ActiveRecord::Base

  has_many :todo_items
  belongs_to :user

  validates :title, length: {minimum: 3}, presence: true


  def has_completed_items?
    todo_items.complete.size > 0
  end

  def has_incomplete_items?
    todo_items.incomplete.size > 0
  end
end