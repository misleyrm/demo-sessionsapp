class Team < ApplicationRecord
  has_many :users
  has_many :sessions
  validates :team_name, presence: true
  accepts_nested_attributes_for :users, :reject_if => lambda { |a| a[:content].blank? }
  has_attached_file :avatar,
                    styles: { :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /^image\/(png|gif|jpeg|jpg)/



end
# has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" },
# storage: :s3,
# s3_credentials: Proc.new{|a| a.instance.s3_credentials }
#
# def s3_credentials
#   {bucket: ENV['S3_BUCKET_NAME'],
#     access_key_id: ENV['AWS_ACCESS_KEY_ID'],
#     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#     s3_region: ENV['AWS_REGION']
#   }
# end
# # :s3_credentials => "#{Rails.root}/config/.yml",
# # :path => ":attachment/:id/:style.:extension",
# # :bucket => ENV['S3_BUCKET_NAME'],
# # :default_url => "/images/:style/missing.png"
# #
# validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
