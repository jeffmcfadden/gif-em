BULK_IMPORT_DIRECTORY = '/full/path/to/your/images'

Dir[ File.join(BULK_IMPORT_DIRECTORY, '**', '*') ].reject { |p| File.directory? p }.each do |item|
  next if item == '.' or item == '..' or item == '.DS_Store'

  item = item.gsub( "#{BULK_IMPORT_DIRECTORY}/", '' )

  full_path = "#{BULK_IMPORT_DIRECTORY}/#{item}"

  uploaded_path = "bulk-uploaded-2/#{item}"

  image = Image.new

  image.name = "#{item}"

  image.asset_filename = item
  image.asset_file_path = uploaded_path
  image.asset_original_filename = item
  image.asset_stored_privately = false
  image.asset_size = File.size( full_path )

  if item[-4,4] == 'jpeg' || item[-3,3] == 'jpg'
    image.asset_type = 'image/jpeg'
  elsif item[-3,3] == 'gif'
    image.asset_type = 'image/gif'
  elsif item[-3,3] == 'png'
    image.asset_type = 'image/png'
  end

  image.save
end