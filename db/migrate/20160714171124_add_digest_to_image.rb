class AddDigestToImage < ActiveRecord::Migration
  def change
    add_column :images, :digest, :string
    add_index :images, :digest
  end
end
