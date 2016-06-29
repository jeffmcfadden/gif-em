class AddConfidenceToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :confidence, :float, default: 100

    add_index :taggings, :confidence
    add_index :taggings, [:tag_id, :confidence]
  end
end
