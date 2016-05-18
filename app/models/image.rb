class Image < ActiveRecord::Base
  acts_as_taggable
  anaconda_for :asset, base_key: :asset_key

  def asset_key
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    s = (0...24).map { o[rand(o.length)] }.join
    "assets/#{s}"
  end


end
