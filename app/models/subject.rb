# frozen_string_literal: true

# Model for the subjects
class Subject < ApplicationRecord
  validates :name, presence: true

  has_many :subject_times, inverse_of: :subject, dependent: :destroy
  has_many :tasks, inverse_of: :subject, dependent: :destroy

  after_create :create_subject_times

  private

  def create_subject_times
    Group.find_each do |group|
      subject_time = subject_times.find_or_initialize_by(group_id: group.id)
      subject_time.save
    end
  end
end
