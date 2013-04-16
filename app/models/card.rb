class Card < ActiveRecord::Base
  attr_accessible :reference, :scripture, :subject

  validates :scripture, presence: true
  validate :at_least_one_subject_or_reference

  private

  def at_least_one_subject_or_reference
    if String(subject).empty? && String(reference).empty?
      errors[:base] << "Please include a reference or subject"
    end
  end
end
