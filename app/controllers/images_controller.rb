class ImagesController < ApplicationController
  
  before_action :load_image, only: [:show, :update, :add_tag, :remove_tag, :imagga]

  def index
    if params[:q].present?
      
      where_clause = params[:q].split( "," ).collect{ |s| "name ILIKE '%#{s.strip}%' ESCAPE '!'"}.join( " OR " )
      
      tag_ids = ActsAsTaggableOn::Tag.where( where_clause ).collect{ |t| t.id }
      
      @taggings = ActsAsTaggableOn::Tagging.includes( :taggable ).where( tag_id: tag_ids ).order( "confidence DESC, taggings.created_at DESC" ).page( params[:page] ).per( 24 )
      
      @images = @taggings.collect{ |t| t.taggable }
      
      if @images.size == 1
        redirect_to @images.first and return
      end
    else
      @images = Image.all.order("RANDOM()").first(4)
    end
  end
  
  def tag_cloud
    @tags = Image.tag_counts_on(:tags)
    
    
  end

  def show
  end

  def update
    if @image.update_attributes( image_params )
      if params[:untagged] && @untagged_image = Image.untagged.last
        redirect_to image_path(@untagged_image, untagged: true)
      else
        redirect_to @image
      end
    else
      flash[:notice] = "Image failed to save."
      redirect_to @image
    end
  end
  
  def create_from_url
    @image = Image.import_from_url(params[:image_url].strip)
    redirect_to image_path(@image)
  end

  def create
    @image = Image.new( image_params )

    if @image.save
      redirect_to image_path(@image, untagged: true)
    else
      flash[:notice] = "Image failed to save."
      redirect_to images_path
    end
  end
  
  def add_tag
    @image.tag_list.add(params[:image][:tag].split(","))
    @image.save
    redirect_to @image
  end

  def remove_tag
    @image.tag_list.remove(params[:tag])
    @image.save
    redirect_to @image
  end
  
  def imagga
    @image.set_imagga_tags!
    redirect_to @image
  end

  private

  def image_params
    params.require(:image).permit(
            :name,
            :tag_list,
            Image.anaconda_fields_for( :asset )
            )
  end
  
  def load_image
    @image = Image.find(params[:id])
  end

end
