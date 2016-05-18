class AnacondaMigrationForImageAsset < ActiveRecord::Migration
  def change
    add_column :images, :asset_filename, :string
    add_column :images, :asset_file_path, :text
    add_column :images, :asset_size, :integer
    add_column :images, :asset_original_filename, :text
    add_column :images, :asset_stored_privately, :boolean
    add_column :images, :asset_type, :string
  end
end
