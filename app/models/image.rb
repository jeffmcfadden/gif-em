require 'base64'
require 'open-uri'
require 'digest'

class Image < ActiveRecord::Base
  acts_as_taggable
  anaconda_for :asset, base_key: :asset_key, host: ENV['IMAGE_HOSTNAME']
  attr_accessor :extension_for_upload

  scope :untagged, ->{ tagged_with(ActsAsTaggableOn::Tag.all.map(&:to_s), exclude: true) }
  
  def self.set_all_imagga_tags!(max_tag_count: 10)
    # Ignore things that have tags over the threshold
    Image.find_each do |image|
      next if image.tags.size > max_tag_count
      begin
        sleep(1)
        puts "Tagging: #{image.id}..."
        image.set_imagga_tags!
        print "Success! Added #{image.tags.size} tags"
      rescue => e
        print "Failed: #{e.message}"
        next
      end
    end
  end
  
  def self.update_all_hashes!
    Image.find_each do |image|
      puts "Updating hash for #{image.id}"
      begin
        image.update_hash!
      rescue Exception => ex
        puts "  Failed to update hash for #{image.id}: #{ex}"
      end
    end
  end
  
  def self.import_from_url(url)
    image = Image.create
    image.extension_for_upload = File.extname(url)
    image.import_file_to_anaconda_column(url, :asset)
    return image
  end

  def asset_key
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    s = (0...24).map { o[rand(o.length)] }.join
    "assets/#{s}#{extension_for_upload}"
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
  
  def tag_list_with_confidence
  taggings.order( confidence: :desc, created_at: :desc )
  end
  
  def tag_list_by_confidence
    tag_list_with_confidence.collect{ |t| t.tag.name }
  end
  
  def update_hash!
    data = open( asset_url ).read
    digest = Digest::SHA256.hexdigest data
    self.update_attributes( digest: digest )
  end


end
