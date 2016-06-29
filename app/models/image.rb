require 'base64'

class Image < ActiveRecord::Base
  acts_as_taggable
  anaconda_for :asset, base_key: :asset_key, host: ENV['IMAGE_HOSTNAME']

  scope :untagged, ->{ tagged_with(ActsAsTaggableOn::Tag.all.map(&:to_s), exclude: true) }

  def asset_key
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    s = (0...24).map { o[rand(o.length)] }.join
    "assets/#{s}"
  end
  
  def get_imagga_tags
    image_url = asset_url
    api_key    = ENV['IMAGGA_API_KEY']
    api_secret = ENV['IMAGGA_API_SECRET']

    auth = 'Basic ' + Base64.strict_encode64( "#{api_key}:#{api_secret}" ).chomp
    response = RestClient.get "https://api.imagga.com/v1/tagging?url=#{image_url}", { :Authorization => auth }

    tags = JSON.parse( response )
  end
  
  def set_imagga_tags!
    data = get_imagga_tags
    data["results"][0]["tags"].each do |t|
      
      if t["confidence"] > 15      
        self.tag_list.add( t["tag"] )
        save
        self.taggings.order( created_at: :desc ).first.update_attributes( confidence: t["confidence"] )
      end
    end
  end
  
  def tag_list_by_confidence
    taggings.order( confidence: :desc, created_at: :desc ).collect{ |t| t.tag.name }
  end


end
