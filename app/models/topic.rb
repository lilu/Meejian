class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String, default: ""
  field :subtitle, type: String, default: ""
  field :description, type: String, default: ""
  field :questions, type: Array, default: []
  field :interactive, type: Boolean, default: true
  field :recommend, type: Boolean, default: false
  mount_uploader :photo, PhotosUploader

  slug :title

  belongs_to :category
  belongs_to :editor, class_name: "User", inverse_of: :editable_topic

  has_many :interviews, dependent: :restrict

  validates :title, presence: true, uniqueness: true
  validates :subtitle, presence: true
  validates :category, presence: true

  before_validation { questions.reject! {|i| i.blank?} }

  default_scope desc(:created_at)
  scope :recommended, where(recommend: true)
end
