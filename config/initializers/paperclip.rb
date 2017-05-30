# # Paperclip::Attachment.default_options[:s3_host_name] = 'us-west-2'
#
# Rails.application.config.before_initialize do
#   Paperclip::Attachment.default_options[:url] = ':popstar.s3.amazonaws.com'
#
#   Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
# end
#
# Paperclip::Attachment.default_options[:s3_host_name] = 'us-standard.amazonaws.com'
# Paperclip::Attachment.default_options[:s3_region] = ENV['AWS_REGION']
# Paperclip::Attachment.default_options[:bucket] = ENV['S3_BUCKET_NAME']
# config/initializers/paperclip.rb
  # only use Amazon S2 on production servers


Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_protocol] = 'https'
Paperclip::Attachment.default_options[:s3_credentials] =
  { :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    :bucket => ENV['S3_BUCKET_NAME'],
    :s3_region => ENV['AWS_REGION']
   }

  # # config/initializers/paperclip.rb
  # Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-2.amazonaws.com'

  Paperclip::Attachment.default_options[:url] = ':s3.amazonaws.com'
  Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
