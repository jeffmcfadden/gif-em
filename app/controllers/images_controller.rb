class ImagesController < ApplicationController
  
  before_action :load_image, only: [:show, :update, :add_tag, :remove_tag, :imagga]

  def index
    if params[:q].present?
      @images = Image.tagged_with( params[:q] ).order( created_at: :desc ).page( params[:page] ).per( 24 )
      if @images.size == 1
        redirect_to @images.first and return
      end
    else
      @images = Image.all.order("RANDOM()").first(4)
    end
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
