# -*- coding: utf-8 -*-
class Interview < Post
  embeds_many :answers
  belongs_to :topic

  accepts_nested_attributes_for :answers

  validate do |interview|
    errors.add(:base, "至少请回答一个问题") if interview.valid_answers.blank?
  end

  validates_uniqueness_of :author_id, scope: :topic_id,
  message: "您不能提交对同一个主题的多次访谈"

  scope :recommended, where(recommend: true)
  scope :not_recommended, where(recommend: false)
  default_scope desc(:created_at)

  class << self
    def find_by_topic_and_author(topic, author)
      where(topic: topic, author: author).first
    end
  end

  def valid_answers
    answers.reject { |a| a.answer.blank? }
  end

  def recommend_answer
    answers.where(recommend: true).first or valid_answers.first
  end
end
